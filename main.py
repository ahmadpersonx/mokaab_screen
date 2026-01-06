# main.py
# Version: v1.0.2
# Description: نقطة الدخول لاستخراج البيانات وحفظ كل سطر كـ JSON داخل خلية إكسل.

from services.production_stats_aggregator import ProductionStatsAggregator
import os

def main():
    # 1. تحديد المسارات
    excel_file_name = "arry.xlsx"
    # اسم الملف الناتج الجديد (إكسل)
    output_file_name = "output_cells.xlsx" 
    
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, excel_file_name)
    output_path = os.path.join(current_dir, output_file_name)

    print(f"جاري قراءة الملف: {excel_file_name} ...")

    # 2. تهيئة الخدمة
    aggregator = ProductionStatsAggregator(file_path)

    # 3. التنفيذ
    print("جاري المعالجة والحفظ في ملف إكسل جديد...")
    success, count = aggregator.export_rows_as_json_cells_to_excel(output_path)

    if success:
        print(f"\n✅ تمت العملية بنجاح!")
        print(f"تمت معالجة {count} سطر.")
        print(f"تم حفظ الملف الجديد باسم: {output_file_name}")
        print("افتح الملف الجديد، وستجد عموداً واحداً يحتوي على كود JSON لكل سطر.")
    else:
        print("\n❌ فشلت العملية.")

if __name__ == "__main__":
    main()