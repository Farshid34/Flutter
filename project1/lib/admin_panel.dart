import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/login.dart';
import 'package:project1/login2.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AddProductPage(),
    EditProductPage(),
    DeleteProductPage(),
    AddUserPage(),
    EditUserPage(),
    DeleteUserPage(),
    UserListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: const Color.fromARGB(255, 40, 147, 234),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login2()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Delete Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Add User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Edit User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_remove),
            label: 'Delete User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users List',
          ),
        ],
      ),
    );
  }
}

// ==================== صفحه اضافه کردن محصول ====================
class AddProductPage extends StatefulWidget {
  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  // لیست دسته‌بندی‌های مجاز
  final List<String> _validCategories = [
    'electronics',
    'jewelery',
    'men\'s clothing',
    'women\'s clothing',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(
              icon: Icons.add_shopping_cart,
              title: 'Add New Product',
              color: Colors.green,
            ),

            SizedBox(height: 30),

            // Product ID
            _buildTextField(
              controller: _idController,
              label: 'Product ID',
              icon: Icons.tag,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product ID';
                }
                final id = int.tryParse(value);
                if (id == null) {
                  return 'Product ID must be a number';
                }
                if (id <= 0) {
                  return 'Product ID must be greater than 0';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Title
            _buildTextField(
              controller: _titleController,
              label: 'Product Title',
              icon: Icons.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product title';
                }
                if (value.length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Price
            _buildTextField(
              controller: _priceController,
              label: 'Price (\$)',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Description
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              icon: Icons.description,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                if (value.length < 10) {
                  return 'Description must be at least 10 characters';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Image URL
            _buildTextField(
              controller: _imageController,
              label: 'Image URL',
              icon: Icons.image,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter image URL';
                }
                if (!value.startsWith('http')) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Category
            _buildTextField(
              controller: _categoryController,
              label:
                  'Category (electronics, jewelery, men\'s clothing, women\'s clothing)',
              icon: Icons.category,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category';
                }
                // چک کردن اینکه جزو دسته‌های مجاز باشه
                if (!_validCategories.contains(value.toLowerCase())) {
                  return 'Invalid category! Choose from: electronics, jewelery, men\'s clothing, women\'s clothing';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Rating
            _buildTextField(
              controller: _ratingController,
              label: 'Rating (0-5)',
              icon: Icons.star,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter rating';
                }
                final rating = double.tryParse(value);
                if (rating == null || rating < 0 || rating > 5) {
                  return 'Rating: 0-5';
                }
                return null;
              },
            ),

            SizedBox(height: 30),

            // Submit Button
            ElevatedButton.icon(
              onPressed: _submitProduct,
              icon: Icon(Icons.check_circle, size: 24),
              label: Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      // نمایش Toast موفقیت
      Fluttertoast.showToast(
        msg: '✅ Product added successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // پاک کردن فرم
      _formKey.currentState!.reset();
      _idController.clear();
      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _imageController.clear();
      _categoryController.clear();
      _ratingController.clear();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _ratingController.dispose();
    super.dispose();
  }
}

// ==================== صفحه ویرایش محصول ====================
class EditProductPage extends StatefulWidget {
  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _searchFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  bool _productFound = false;
  bool _searched = false;

  // لیست دسته‌بندی‌های مجاز
  final List<String> _validCategories = [
    'electronics',
    'jewelery',
    'men\'s clothing',
    'women\'s clothing',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            icon: Icons.edit_note,
            title: 'Edit Product',
            color: Colors.orange,
          ),

          SizedBox(height: 30),

          // بخش جستجو
          Form(
            key: _searchFormKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _searchController,
                  label: 'Product ID or Title',
                  icon: Icons.search,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Product ID or Title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _searchProduct,
                  icon: Icon(Icons.search),
                  label: Text('Search Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_searched) ...[
            SizedBox(height: 30),
            Divider(thickness: 2),
            SizedBox(height: 20),

            if (_productFound) ...[
              // فرم ویرایش
              Form(
                key: _editFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Edit Product Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 20),

                    _buildTextField(
                      controller: _idController,
                      label: 'Product ID',
                      icon: Icons.tag,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product ID';
                        }
                        final id = int.tryParse(value);
                        if (id == null) {
                          return 'Product ID must be a number';
                        }
                        if (id <= 0) {
                          return 'Product ID must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _titleController,
                      label: 'Product Title',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product title';
                        }
                        if (value.length < 3) {
                          return 'Title must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _priceController,
                      label: 'Price (\$)',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      icon: Icons.description,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        if (value.length < 10) {
                          return 'Description must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _imageController,
                      label: 'Image URL',
                      icon: Icons.image,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter image URL';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _categoryController,
                      label:
                          'Category (electronics, jewelery, men\'s clothing, women\'s clothing)',
                      icon: Icons.category,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category';
                        }
                        // چک کردن اینکه جزو دسته‌های مجاز باشه
                        if (!_validCategories.contains(value.toLowerCase())) {
                          return 'Invalid category! Choose from: electronics, jewelery, men\'s clothing, women\'s clothing';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _ratingController,
                      label: 'Rating (0-5)',
                      icon: Icons.star,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter rating';
                        }
                        final rating = double.tryParse(value);
                        if (rating == null || rating < 0 || rating > 5) {
                          return 'Rating: 0-5';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: _updateProduct,
                      icon: Icon(Icons.update, size: 24),
                      label: Text('Update Product'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _searchProduct() {
    if (_searchFormKey.currentState!.validate()) {
      // شبیه‌سازی جستجو (50% احتمال پیدا شدن)
      final random = Random();
      final found = random.nextBool();

      setState(() {
        _searched = true;
        _productFound = found;
      });

      if (found) {
        // پر کردن فیلدها با داده‌های نمونه
        _idController.text = '123';
        _titleController.text = 'Sample Product';
        _priceController.text = '99.99';
        _descriptionController.text = 'This is a sample product description';
        _imageController.text =
            'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg';
        _categoryController.text = 'electronics';
        _ratingController.text = '4.5';

        Fluttertoast.showToast(
          msg: '✅ Product found! You can now edit it.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: '❌ Product not found!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  void _updateProduct() {
    if (_editFormKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: '✅ Product updated successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // ریست فرم
      setState(() {
        _searched = false;
        _productFound = false;
      });
      _searchController.clear();
      _idController.clear();
      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _imageController.clear();
      _categoryController.clear();
      _ratingController.clear();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _idController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _ratingController.dispose();
    super.dispose();
  }
}

// ==================== صفحه حذف محصول ====================
class DeleteProductPage extends StatefulWidget {
  @override
  State<DeleteProductPage> createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(
              icon: Icons.delete_forever,
              title: 'Delete Product',
              color: Colors.red,
            ),

            SizedBox(height: 30),

            _buildTextField(
              controller: _searchController,
              label: 'Product ID or Title',
              icon: Icons.search,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Product ID or Title';
                }
                return null;
              },
            ),

            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _deleteProduct,
              icon: Icon(Icons.delete, size: 24),
              label: Text('Delete Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProduct() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text('Confirm Delete'),
            ],
          ),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmDelete();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        ),
      );
    }
  }

  void _confirmDelete() {
    // شبیه‌سازی حذف (50% احتمال پیدا شدن)
    final random = Random();
    final found = random.nextBool();

    if (found) {
      Fluttertoast.showToast(
        msg: '✅ Product deleted successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: '❌ Product not found!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    _searchController.clear();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// ==================== Widget‌های کمکی ====================

Widget _buildHeader({
  required IconData icon,
  required String title,
  required Color color,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 15,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(icon, size: 40, color: Colors.white),
        SizedBox(width: 15),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.purple, width: 2),
      ),
    ),
    validator: validator,
    keyboardType: keyboardType,
    maxLines: maxLines,
  );
}

// -----------------------------------------------------------------

// ==================== صفحه اضافه کردن کاربر ====================
class AddUserPage extends StatefulWidget {
  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text =
            '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(
              icon: Icons.person_add,
              title: 'Add New User',
              color: Colors.blue,
            ),

            SizedBox(height: 30),

            // First Name - فقط حروف
            _buildTextField(
              controller: _firstNameController,
              label: 'First Name',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter first name';
                }
                if (value.length < 2) {
                  return 'First name must be at least 2 characters';
                }
                if (!RegExp(r'^[a-zA-Zآ-ی\s]+$').hasMatch(value)) {
                  return 'First name can only contain letters';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Last Name - فقط حروف
            _buildTextField(
              controller: _lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter last name';
                }
                if (value.length < 2) {
                  return 'Last name must be at least 2 characters';
                }
                if (!RegExp(r'^[a-zA-Zآ-ی\s]+$').hasMatch(value)) {
                  return 'Last name can only contain letters';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Birth Date با DatePicker
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildTextField(
                  controller: _birthDateController,
                  label: 'Birth Date (YYYY/MM/DD)',
                  icon: Icons.calendar_today,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select birth date';
                    }
                    return null;
                  },
                ),
              ),
            ),

            SizedBox(height: 16),

            // Phone Number - دقیقا 11 رقم
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number (11 digits)',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                if (value.length != 11) {
                  return 'Phone number must be exactly 11 digits';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Phone number can only contain digits';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Email با @ اجباری
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                if (!value.contains('@')) {
                  return 'Email must contain @';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Username - حداقل 3 کاراکتر
            _buildTextField(
              controller: _usernameController,
              label: 'Username (min 3 characters)',
              icon: Icons.account_circle,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username';
                }
                if (value.length < 3) {
                  return 'Username must be at least 3 characters';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Password - حداقل 8 کاراکتر با حروف و اعداد
            _buildTextField(
              controller: _passwordController,
              label: 'Password (min 8 chars, letters & numbers)',
              icon: Icons.lock,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                bool hasLetters = RegExp(r'[a-zA-Z]').hasMatch(value);
                bool hasDigits = RegExp(r'[0-9]').hasMatch(value);
                if (!hasLetters || !hasDigits) {
                  return 'Password must contain both letters and numbers';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Confirm Password
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              icon: Icons.lock_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _submitUser,
              icon: Icon(Icons.check_circle, size: 24),
              label: Text('Add User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitUser() {
    if (_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: '✅ User added successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      _formKey.currentState!.reset();
      _firstNameController.clear();
      _lastNameController.clear();
      _birthDateController.clear();
      _phoneController.clear();
      _emailController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

// ==================== صفحه ویرایش کاربر ====================
class EditUserPage extends StatefulWidget {
  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _searchFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _userFound = false;
  bool _searched = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text =
            '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            icon: Icons.edit,
            title: 'Edit User',
            color: Colors.teal,
          ),

          SizedBox(height: 30),

          Form(
            key: _searchFormKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _searchController,
                  label: 'Username',
                  icon: Icons.search,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _searchUser,
                  icon: Icon(Icons.search),
                  label: Text('Search User'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_searched) ...[
            SizedBox(height: 30),
            Divider(thickness: 2),
            SizedBox(height: 20),

            if (_userFound) ...[
              Form(
                key: _editFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Edit User Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 20),

                    _buildTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        if (value.length < 2) {
                          return 'First name must be at least 2 characters';
                        }
                        if (!RegExp(r'^[a-zA-Zآ-ی\s]+$').hasMatch(value)) {
                          return 'First name can only contain letters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        if (value.length < 2) {
                          return 'Last name must be at least 2 characters';
                        }
                        if (!RegExp(r'^[a-zA-Zآ-ی\s]+$').hasMatch(value)) {
                          return 'Last name can only contain letters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _birthDateController,
                          label: 'Birth Date (YYYY/MM/DD)',
                          icon: Icons.calendar_today,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select birth date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number (11 digits)',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (value.length != 11) {
                          return 'Phone number must be exactly 11 digits';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Phone number can only contain digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!value.contains('@')) {
                          return 'Email must contain @';
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _usernameController,
                      label: 'Username (min 3 characters)',
                      icon: Icons.account_circle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password (min 8 chars, letters & numbers)',
                      icon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        bool hasLetters = RegExp(r'[a-zA-Z]').hasMatch(value);
                        bool hasDigits = RegExp(r'[0-9]').hasMatch(value);
                        if (!hasLetters || !hasDigits) {
                          return 'Password must contain both letters and numbers';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: _updateUser,
                      icon: Icon(Icons.update, size: 24),
                      label: Text('Update User'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _searchUser() {
    if (_searchFormKey.currentState!.validate()) {
      final random = Random();
      final found = random.nextBool();

      setState(() {
        _searched = true;
        _userFound = found;
      });

      if (found) {
        _firstNameController.text = 'Ali';
        _lastNameController.text = 'Ahmadi';
        _birthDateController.text = '1995/05/15';
        _phoneController.text = '09123456789';
        _emailController.text = 'ali.ahmadi@example.com';
        _usernameController.text = _searchController.text;
        _passwordController.text = 'password123';
        _confirmPasswordController.text = 'password123';

        Fluttertoast.showToast(
          msg: '✅ User found! You can now edit it.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: '❌ User not found!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  void _updateUser() {
    if (_editFormKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: '✅ User updated successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      setState(() {
        _searched = false;
        _userFound = false;
      });
      _searchController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _birthDateController.clear();
      _phoneController.clear();
      _emailController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

// ==================== صفحه حذف کاربر ====================
class DeleteUserPage extends StatefulWidget {
  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(
              icon: Icons.person_remove,
              title: 'Delete User',
              color: Colors.deepOrange,
            ),

            SizedBox(height: 30),

            _buildTextField(
              controller: _searchController,
              label: 'Username',
              icon: Icons.search,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username';
                }
                return null;
              },
            ),

            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _deleteUser,
              icon: Icon(Icons.delete, size: 24),
              label: Text('Delete User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUser() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.deepOrange),
              SizedBox(width: 10),
              Text('Confirm Delete'),
            ],
          ),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: Text('Delete'),
            ),
          ],
        ),
      );
    }
  }

  void _confirmDelete() {
    final random = Random();
    final found = random.nextBool();

    if (found) {
      Fluttertoast.showToast(
        msg: '✅ User deleted successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: '❌ User not found!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    _searchController.clear();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// ==================== صفحه لیست کاربران ====================
class UserListPage extends StatefulWidget {
  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final List<Map<String, String>> _users = [
    {
      'username': 'ali_123',
      'firstName': 'علی',
      'lastName': 'احمدی',
      'birthDate': '1995/05/15',
      'phone': '09121234567',
      'email': 'ali.ahmadi@example.com',
      'joinDate': '2024-01-15',
    },
    {
      'username': 'sara_designer',
      'firstName': 'سارا',
      'lastName': 'محمدی',
      'birthDate': '1998/08/20',
      'phone': '09127654321',
      'email': 'sara.designer@example.com',
      'joinDate': '2024-02-20',
    },
    {
      'username': 'mohammad_dev',
      'firstName': 'محمد',
      'lastName': 'رضایی',
      'birthDate': '1992/03/10',
      'phone': '09131112233',
      'email': 'mohammad.dev@example.com',
      'joinDate': '2024-03-10',
    },
    {
      'username': 'maryam_admin',
      'firstName': 'مریم',
      'lastName': 'کریمی',
      'birthDate': '1990/12/25',
      'phone': '09141234567',
      'email': 'maryam.admin@example.com',
      'joinDate': '2024-03-25',
    },
    {
      'username': 'reza_user',
      'firstName': 'رضا',
      'lastName': 'حسینی',
      'birthDate': '1996/04/05',
      'phone': '09151234567',
      'email': 'reza.user@example.com',
      'joinDate': '2024-04-05',
    },
    {
      'username': 'zahra_customer',
      'firstName': 'زهرا',
      'lastName': 'نوری',
      'birthDate': '1999/07/18',
      'phone': '09161234567',
      'email': 'zahra.customer@example.com',
      'joinDate': '2024-04-18',
    },
    {
      'username': 'hassan_buyer',
      'firstName': 'حسن',
      'lastName': 'عباسی',
      'birthDate': '1994/01/01',
      'phone': '09171234567',
      'email': 'hassan.buyer@example.com',
      'joinDate': '2024-05-01',
    },
    {
      'username': 'fateme_shop',
      'firstName': 'فاطمه',
      'lastName': 'جعفری',
      'birthDate': '1997/05/12',
      'phone': '09181234567',
      'email': 'fateme.shop@example.com',
      'joinDate': '2024-05-12',
    },
    {
      'username': 'amir_online',
      'firstName': 'امیر',
      'lastName': 'صادقی',
      'birthDate': '1993/06/08',
      'phone': '09191234567',
      'email': 'amir.online@example.com',
      'joinDate': '2024-06-08',
    },
    {
      'username': 'neda_store',
      'firstName': 'ندا',
      'lastName': 'مرادی',
      'birthDate': '1991/09/22',
      'phone': '09121111111',
      'email': 'neda.store@example.com',
      'joinDate': '2024-06-22',
    },
    {
      'username': 'javad_tech',
      'firstName': 'جواد',
      'lastName': 'رحیمی',
      'birthDate': '1995/07/03',
      'phone': '09122222222',
      'email': 'javad.tech@example.com',
      'joinDate': '2024-07-03',
    },
    {
      'username': 'parisa_web',
      'firstName': 'پریسا',
      'lastName': 'فلاحی',
      'birthDate': '1998/02/19',
      'phone': '09123333333',
      'email': 'parisa.web@example.com',
      'joinDate': '2024-07-19',
    },
    {
      'username': 'mehdi_mobile',
      'firstName': 'مهدی',
      'lastName': 'باقری',
      'birthDate': '1994/08/11',
      'phone': '09124444444',
      'email': 'mehdi.mobile@example.com',
      'joinDate': '2024-08-11',
    },
    {
      'username': 'nazanin_ui',
      'firstName': 'نازنین',
      'lastName': 'امینی',
      'birthDate': '1996/11/26',
      'phone': '09125555555',
      'email': 'nazanin.ui@example.com',
      'joinDate': '2024-08-26',
    },
    {
      'username': 'hossein_code',
      'firstName': 'حسین',
      'lastName': 'نجفی',
      'birthDate': '1992/09/14',
      'phone': '09126666666',
      'email': 'hossein.code@example.com',
      'joinDate': '2024-09-14',
    },
    {
      'username': 'mina_art',
      'firstName': 'مینا',
      'lastName': 'زارعی',
      'birthDate': '1999/03/28',
      'phone': '09127777777',
      'email': 'mina.art@example.com',
      'joinDate': '2024-09-28',
    },
    {
      'username': 'bahram_pro',
      'firstName': 'بهرام',
      'lastName': 'محمودی',
      'birthDate': '1990/10/09',
      'phone': '09128888888',
      'email': 'bahram.pro@example.com',
      'joinDate': '2024-10-09',
    },
    {
      'username': 'somayeh_work',
      'firstName': 'سمیه',
      'lastName': 'اکبری',
      'birthDate': '1997/06/25',
      'phone': '09129999999',
      'email': 'somayeh.work@example.com',
      'joinDate': '2024-10-25',
    },
    {
      'username': 'majid_biz',
      'firstName': 'مجید',
      'lastName': 'حیدری',
      'birthDate': '1993/11/07',
      'phone': '09121010101',
      'email': 'majid.biz@example.com',
      'joinDate': '2024-11-07',
    },
    {
      'username': 'nasrin_shop',
      'firstName': 'نسرین',
      'lastName': 'سلیمانی',
      'birthDate': '1995/08/20',
      'phone': '09122020202',
      'email': 'nasrin.shop@example.com',
      'joinDate': '2024-11-20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.indigo.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.people, size: 40, color: Colors.white),
              SizedBox(width: 15),
              Text(
                'Users List',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_users.length} Users',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Text(
                      user['username']![0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    user['username']!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        'Joined: ${user['joinDate']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right, color: Colors.indigo),
                  onTap: () {
                    _showUserDetails(context, user);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showUserDetails(BuildContext context, Map<String, String> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 600, maxHeight: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blue.shade700],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Text(
                          user['username']![0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user['firstName']} ${user['lastName']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '@${user['username']}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Content - Scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: [
                        // First Name
                        _buildDetailRow(
                          Icons.person,
                          'First Name',
                          user['firstName'] ?? '',
                          Colors.blue,
                        ),
                        SizedBox(height: 20),

                        // Last Name
                        _buildDetailRow(
                          Icons.person_outline,
                          'Last Name',
                          user['lastName'] ?? '',
                          Colors.blue,
                        ),
                        SizedBox(height: 20),

                        // Birth Date
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Birth Date',
                          user['birthDate'] ?? '',
                          Colors.blue,
                        ),
                        SizedBox(height: 20),

                        // Phone Number
                        _buildDetailRow(
                          Icons.phone,
                          'Phone Number',
                          user['phone'] ?? '',
                          Colors.blue,
                        ),
                        SizedBox(height: 20),

                        // Email
                        _buildDetailRow(
                          Icons.email,
                          'Email',
                          user['email'] ?? '',
                          Colors.blue,
                        ),
                        SizedBox(height: 20),

                        // Username
                        _buildDetailRow(
                          Icons.account_circle,
                          'Username',
                          user['username'] ?? '',
                          Colors.blue,
                        ),
                        SizedBox(height: 20),

                        // Join Date
                        _buildDetailRow(
                          Icons.date_range,
                          'Join Date',
                          user['joinDate'] ?? '',
                          Colors.blue,
                        ),

                        SizedBox(height: 10),

                        // Password Info Card
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock,
                                color: Colors.grey.shade600,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '••••••••',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                        letterSpacing: 3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.visibility_off,
                                color: Colors.grey.shade500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer Buttons
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Navigate to edit user page
                          },
                          icon: Icon(Icons.edit, size: 20),
                          label: Text('Edit User'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close, size: 20),
                          label: Text('Close'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 15),
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
