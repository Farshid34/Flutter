import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PersianDateTimePickerApp(),
  ),
);

class PersianDateTimePickerApp extends StatefulWidget {
  const PersianDateTimePickerApp({super.key});

  @override
  State<PersianDateTimePickerApp> createState() =>
      _PersianDateTimePickerAppState();
}

class _PersianDateTimePickerAppState extends State<PersianDateTimePickerApp> {
  // متغیرهای تاریخ
  String selectedDate = 'تاریخ را انتخاب کنید';
  Jalali? pickedDate;

  // متغیرهای ساعت
  String selectedTime = 'ساعت را انتخاب کنید';
  TimeOfDay? pickedTime;

  // متغیرهای ترکیبی
  String dateTimeDisplay = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('انتخاب تاریخ و ساعت شمسی'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==================== بخش ۱: انتخاب تاریخ ====================
            Card(
              elevation: 4,
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.calendar_today, size: 60, color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'تاریخ انتخاب شده',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Text(
                        selectedDate,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Jalali? picked = await showPersianDatePicker(
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1300, 1, 1),
                            lastDate: Jalali(1500, 12, 29),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            setState(() {
                              pickedDate = picked;
                              selectedDate = picked.formatFullDate();
                              _updateDateTime();
                            });
                          }
                        },
                        icon: Icon(Icons.event),
                        label: const Text('انتخاب تاریخ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // ==================== بخش ۲: انتخاب ساعت ====================
            Card(
              elevation: 4,
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.access_time, size: 60, color: Colors.orange),
                    SizedBox(height: 16),
                    Text(
                      'ساعت انتخاب شده',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Text(
                        selectedTime,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // نمایش Time Picker شمسی
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.orange,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            setState(() {
                              pickedTime = picked;
                              selectedTime = _formatTime(picked);
                              _updateDateTime();
                            });
                          }
                        },
                        icon: Icon(Icons.schedule),
                        label: const Text('انتخاب ساعت'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // ==================== بخش ۳: نمایش ترکیبی ====================
            if (dateTimeDisplay.isNotEmpty)
              Card(
                elevation: 6,
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, size: 60, color: Colors.green),
                      SizedBox(height: 16),
                      Text(
                        'تاریخ و ساعت کامل',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  selectedDate,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.access_time, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  selectedTime,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 24),
                            Text(
                              dateTimeDisplay,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20),

            // ==================== بخش ۴: دکمه‌های اضافی ====================
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedDate = 'تاریخ را انتخاب کنید';
                        selectedTime = 'ساعت را انتخاب کنید';
                        dateTimeDisplay = '';
                        pickedDate = null;
                        pickedTime = null;
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: const Text('پاک کردن'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (pickedDate != null && pickedTime != null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.info, color: Colors.teal),
                                SizedBox(width: 8),
                                Text('اطلاعات کامل'),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('تاریخ کامل:', selectedDate),
                                _buildInfoRow('ساعت:', selectedTime),
                                _buildInfoRow(
                                  'فرمت کوتاه:',
                                  pickedDate!.formatCompactDate(),
                                ),
                                _buildInfoRow(
                                  'روز هفته:',
                                  pickedDate!.formatter.wN,
                                ),
                                _buildInfoRow('ماه:', pickedDate!.formatter.mN),
                                _buildInfoRow(
                                  'سال:',
                                  pickedDate!.year.toString(),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('بستن'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'لطفاً ابتدا تاریخ و ساعت را انتخاب کنید',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.info_outline),
                    label: const Text('جزئیات'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // ==================== بخش ۵: نمایش اطلاعات اضافی ====================
            if (pickedDate != null)
              Card(
                elevation: 3,
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اطلاعات تاریخ انتخابی',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      Divider(),
                      _buildInfoTile(
                        Icons.today,
                        'روز هفته',
                        pickedDate!.formatter.wN,
                        Colors.purple,
                      ),
                      _buildInfoTile(
                        Icons.calendar_month,
                        'ماه',
                        pickedDate!.formatter.mN,
                        Colors.purple,
                      ),
                      _buildInfoTile(
                        Icons.event_note,
                        'سال',
                        pickedDate!.year.toString(),
                        Colors.purple,
                      ),
                      _buildInfoTile(
                        Icons.format_list_numbered,
                        'فرمت کوتاه',
                        pickedDate!.formatCompactDate(),
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // تابع فرمت کردن ساعت
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    // تبدیل اعداد به فارسی
    return _toPersianNumber('$hour:$minute');
  }

  // تابع تبدیل اعداد به فارسی
  String _toPersianNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], farsi[i]);
    }
    return input;
  }

  // به‌روزرسانی نمایش ترکیبی
  void _updateDateTime() {
    if (pickedDate != null && pickedTime != null) {
      setState(() {
        dateTimeDisplay = '${selectedDate} - ساعت ${selectedTime}';
      });
    }
  }

  // ویجت کمکی برای نمایش اطلاعات
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // ویجت کمکی برای نمایش آیتم‌های اطلاعاتی
  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.orange[800]),
          ),
        ],
      ),
    );
  }
}
