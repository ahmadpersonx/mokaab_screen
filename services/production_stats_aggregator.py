# services/production_stats_aggregator.py
# Version: v1.0.6
# Description: خدمة مسؤولة عن معالجة ملفات الإكسل وتجهيز البيانات للتصدير.
# Updates: تم إضافة تقريب الأرقام (Rounding) إلى خانتين عشريتين لجميع البيانات المصدرة.

import pandas as pd
import json
import os

class ProductionStatsAggregator:
    def __init__(self, file_path):
        self.file_path = file_path
        # الأعمدة التي سيتم استخراجها
        self.columns_to_extract = [
            "bagsCount",
            "itemsCount",
            "bagWeightKg",
            "totalPieces",
            "bagsUsedCount",
            "totalWeightKg",
            "avgPieceWeightKg"
        ]

    def _read_data(self):
        """دالة مساعدة لقراءة البيانات وتنظيفها"""
        if not os.path.exists(self.file_path):
            print(f"Error: File not found at {self.file_path}")
            return None
        try:
            df = pd.read_excel(self.file_path)
            # استبدال القيم الفارغة بأصفار
            df.fillna(0, inplace=True)
            return df
        except Exception as e:
            print(f"Exception during reading: {e}")
            return None

    def export_rows_as_json_cells_to_excel(self, output_excel_path):
        """
        تقوم هذه الدالة بإنشاء ملف إكسل جديد.
        كل خلية في العمود 'json_data' تحتوي على JSON للسطر المقابل.
        """
        df = self._read_data()
        if df is None: return False, 0

        # التحقق من وجود الأعمدة
        existing_cols = [c for c in self.columns_to_extract if c in df.columns]
        if not existing_cols: return False, 0

        # أخذ نسخة من البيانات المطلوبة
        subset_df = df[existing_cols].copy()

        # --- التحديث الجديد: التقريب لأقرب خانتين عشريتين ---
        # يتم تطبيق التقريب على كامل الجدول قبل التحويل
        subset_df = subset_df.round(2)

        print("جاري تحويل الصفوف إلى نصوص JSON (مع التقريب)...")
        
        # تحويل كل سطر إلى نص JSON
        # force_ascii=False لضمان ظهور العربية بشكل صحيح
        json_series = subset_df.apply(lambda x: x.to_json(force_ascii=False), axis=1)

        # وضع النتائج في DataFrame جديد بخلية واحدة
        result_df = pd.DataFrame({'json_data': json_series})

        try:
            result_df.to_excel(output_excel_path, index=False)
            return True, len(result_df)
        except Exception as e:
            print(f"Error saving Excel file: {e}")
            return False, 0

    def get_all_records(self):
        """إرجاع كافة الصفوف كقائمة (للاستخدامات الأخرى)"""
        df = self._read_data()
        if df is None: return []

        existing_cols = [c for c in self.columns_to_extract if c in df.columns]
        if not existing_cols: return []

        # نقوم بالتقريب هنا أيضاً لضمان توحيد شكل البيانات في كل مكان
        records = df[existing_cols].round(2).to_dict(orient='records')
        return records

    def save_all_records_to_json(self, output_path):
        """حفظ كافة السجلات في ملف JSON خارجي (Minified)"""
        data = self.get_all_records()
        try:
            with open(output_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, separators=(',', ':'))
            return True, len(data)
        except Exception as e:
            print(f"Error saving file: {e}")
            return False, 0

    def get_json_output(self):
        """إرجاع إجمالي المجاميع (Aggregation)"""
        # ملاحظة: المجاميع عادة نتركها بدقة عالية، لكن يمكن تقريبها هنا إذا أردت
        # سأبقيها كما هي للحفاظ على دقة الحسابات التراكمية، 
        # حيث أن التقريب تم تطبيقه على (تصدير الصفوف) حسب طلبك.
        data = self.process_and_aggregate()
        if data:
            return json.dumps(data, indent=4, ensure_ascii=False)
        return "{}"

    def process_and_aggregate(self):
        """حساب المجاميع الكلية (تم الاحتفاظ بها من الإصدارات السابقة)"""
        df = self._read_data()
        if df is None: return None
        
        results = {}
        for col in self.columns_to_extract:
            if col in df.columns and col != "avgPieceWeightKg":
                val = pd.to_numeric(df[col], errors='coerce').sum()
                results[col] = val.item() if hasattr(val, 'item') else val
            elif col != "avgPieceWeightKg":
                results[col] = 0.0

        total_weight = results.get("totalWeightKg", 0)
        total_pieces = results.get("totalPieces", 0)
        if total_pieces > 0:
            results["avgPieceWeightKg"] = total_weight / total_pieces
        else:
            results["avgPieceWeightKg"] = 0.0
            
        return results