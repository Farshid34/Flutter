import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPanel extends StatefulWidget {
  const UserPanel({Key? key}) : super(key: key);

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ProfilePage(),
    CartPage(),
    OrdersPage(),
    WalletPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF667eea),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Shopping Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), // آیکون کیف پول
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== PROFILE PAGE ====================
class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Original values - will be updated after each save
  String _originalFirstName = 'Farshid';
  String _originalLastName = 'Farhadi';
  String _originalBirthDate = '2002/10/21';
  String _originalPhone = '09393172068';
  String _originalEmail = 'f.farhadi9292@gmail.com';
  String _originalUsername = 'farshid';

  final TextEditingController _firstNameController = TextEditingController(
    text: 'Farshid',
  );
  final TextEditingController _lastNameController = TextEditingController(
    text: 'Farhadi',
  );
  final TextEditingController _birthDateController = TextEditingController(
    text: '2002/10/21',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '09393172068',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'f.farhadi9292@gmail.com',
  );
  final TextEditingController _usernameController = TextEditingController(
    text: 'farshid',
  );
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _hasChanges = false; // Track if there are changes

  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers
    _firstNameController.addListener(_checkForChanges);
    _lastNameController.addListener(_checkForChanges);
    _birthDateController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _usernameController.addListener(_checkForChanges);
    _passwordController.addListener(_checkForChanges);
    _confirmPasswordController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    bool hasChanges =
        _firstNameController.text != _originalFirstName ||
        _lastNameController.text != _originalLastName ||
        _birthDateController.text != _originalBirthDate ||
        _phoneController.text != _originalPhone ||
        _emailController.text != _originalEmail ||
        _usernameController.text != _originalUsername ||
        _passwordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFfdfbfb), Color(0xFFebedee)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      'FF',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF667eea),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Update your personal information',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // First Name
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return 'Incorrect - Only letters allowed';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Last Name
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return 'Incorrect - Only letters allowed';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Birth Date
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: _buildTextField(
                            controller: _birthDateController,
                            label: 'Birth Date',
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

                      // Phone Number
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.length != 11) {
                            return 'Incorrect - Phone must be 11 digits';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Incorrect - Only numbers allowed';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Email
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
                            return 'Incorrect - Email must contain @';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Incorrect - Invalid email format';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Username
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
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

                      // New Password
                      _buildPasswordField(
                        controller: _passwordController,
                        label: 'New Password (optional)',
                        icon: Icons.lock,
                        obscure: _obscurePassword,
                        onToggle: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                          // Password is optional, but if provided must be valid
                          if (value != null && value.isNotEmpty) {
                            if (value.length < 8) {
                              return 'Incorrect - Password must be at least 8 characters';
                            }
                            if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                              return 'Incorrect - Password must contain letters';
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'Incorrect - Password must contain numbers';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Confirm Password
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscure: _obscureConfirmPassword,
                        onToggle: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                          // Only validate if password field has value
                          if (_passwordController.text.isNotEmpty) {
                            if (value != _passwordController.text) {
                              return 'Incorrect - Passwords do not match';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),

                      // Save Button - Smart Enable/Disable
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _hasChanges ? _saveProfile : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: _hasChanges
                                  ? LinearGradient(
                                      colors: [
                                        Color(0xFF667eea),
                                        Color(0xFF764ba2),
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.grey.shade300,
                                        Colors.grey.shade400,
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: _hasChanges ? 1.0 : 0.5,
                                child: Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (!_hasChanges)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Make changes to enable save button',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF667eea)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF667eea), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF667eea)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Color(0xFF667eea),
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF667eea), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Update original values with current values
      _originalFirstName = _firstNameController.text;
      _originalLastName = _lastNameController.text;
      _originalBirthDate = _birthDateController.text;
      _originalPhone = _phoneController.text;
      _originalEmail = _emailController.text;
      _originalUsername = _usernameController.text;

      // Clear password fields after save
      _passwordController.clear();
      _confirmPasswordController.clear();

      Fluttertoast.showToast(
        msg: '✅ Profile updated successfully!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16,
      );

      // Reset the hasChanges flag after successful save
      setState(() {
        _hasChanges = false;
      });
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

// ==================== CART PAGE ====================
class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Random _random = Random();
  bool _isCartEmpty = false;
  List<dynamic> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartProducts();
  }

  Future<void> _loadCartProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products?limit=4'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> allProducts = json.decode(response.body);

        // Random decision: empty cart or fill with products
        _isCartEmpty = _random.nextBool();

        if (_isCartEmpty) {
          _cartItems = [];
        } else {
          // Random number of items (1-3)
          int itemCount = _random.nextInt(3) + 1;
          List<dynamic> shuffled = List.from(allProducts)..shuffle();
          _cartItems = shuffled.take(itemCount).toList();
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading cart products: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isCartEmpty = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFfdfbfb), Color(0xFFebedee)],
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFfdfbfb), Color(0xFFebedee)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.white, size: 32),
                  SizedBox(width: 15),
                  Text(
                    'Shopping Cart',
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_cartItems.length} Items',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isCartEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 100,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Add some products to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(20),
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              return _buildCartItem(_cartItems[index]);
                            },
                          ),
                        ),
                        _buildCartSummary(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(dynamic product) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showProductDetails(product, context),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      product['image'] ?? '',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image, color: Colors.grey);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['title'] ?? 'No Title',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${product['price'] ?? 0}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667eea),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _cartItems.remove(product);
                      if (_cartItems.isEmpty) {
                        _isCartEmpty = true;
                      }
                    });
                    Fluttertoast.showToast(
                      msg: 'Item removed from cart',
                      backgroundColor: Colors.orange,
                    );
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    double total = _cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price']?.toDouble() ?? 0.0),
    );

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667eea),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: '✅ Order placed successfully!',
                  backgroundColor: Colors.green,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showProductDetails(dynamic product, BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext modalContext) => Container(
      height: MediaQuery.of(modalContext).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    product['image'] ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              product['title'] ?? 'No Title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '\$${product['price'] ?? 0}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 5),
                    Text(
                      '${product['rating']?['rate'] ?? 0}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Category: ${product['category'] ?? 'N/A'}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 15),
            Text(
              'Description:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              product['description'] ?? 'No description available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ==================== ORDERS PAGE ====================
class OrdersPage extends StatefulWidget {
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  Map<String, List<dynamic>> _orders = {
    'processing': [],
    'shipped': [],
    'delivered': [],
  };
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products?limit=3'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> allProducts = json.decode(response.body);

        bool allEmpty = _random.nextBool();

        if (allEmpty) {
          _orders = {'processing': [], 'shipped': [], 'delivered': []};
        } else {
          List<String> statuses = ['processing', 'shipped', 'delivered'];
          String selectedStatus = statuses[_random.nextInt(statuses.length)];

          _orders = {'processing': [], 'shipped': [], 'delivered': []};

          // Add one random product to selected status
          if (allProducts.isNotEmpty) {
            dynamic randomProduct =
                allProducts[_random.nextInt(allProducts.length)];
            _orders[selectedStatus]!.add(randomProduct);
          }
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading orders: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFfdfbfb), Color(0xFFebedee)],
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFfdfbfb), Color(0xFFebedee)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.white, size: 32),
                      SizedBox(width: 15),
                      Text(
                        'My Orders',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelColor: Color(0xFF667eea),
                      unselectedLabelColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.hourglass_empty, size: 20),
                          text: 'Processing',
                        ),
                        Tab(
                          icon: Icon(Icons.local_shipping, size: 20),
                          text: 'Shipped',
                        ),
                        Tab(
                          icon: Icon(Icons.check_circle, size: 20),
                          text: 'Delivered',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(
                    _orders['processing']!,
                    Icons.hourglass_empty,
                    Colors.orange,
                    'Processing',
                  ),
                  _buildOrderList(
                    _orders['shipped']!,
                    Icons.local_shipping,
                    Colors.blue,
                    'Shipped',
                  ),
                  _buildOrderList(
                    _orders['delivered']!,
                    Icons.check_circle,
                    Colors.green,
                    'Delivered',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(
    List<dynamic> orders,
    IconData icon,
    Color color,
    String status,
  ) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 80, color: color.withOpacity(0.5)),
            ),
            SizedBox(height: 20),
            Text(
              'No $status Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your $status orders will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderItem(orders[index], color);
      },
    );
  }

  Widget _buildOrderItem(dynamic order, Color statusColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showOrderDetails(order),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      order['image'] ?? '',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image, color: Colors.grey);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['title'] ?? 'No Title',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$${order['price'] ?? 0}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF667eea),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, size: 8, color: statusColor),
                                SizedBox(width: 5),
                                Text(
                                  'Order #${order['id'] ?? 0}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(dynamic order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Order Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      order['image'] ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                order['title'] ?? 'No Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '\$${order['price'] ?? 0}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              _buildDetailRow('Order ID', '#${order['id'] ?? 0}2024'),
              SizedBox(height: 10),
              _buildDetailRow(
                'Order Date',
                '2024-12-${15 + (order['id'] ?? 0)}',
              ),
              SizedBox(height: 10),
              _buildDetailRow('Payment', 'Credit Card'),
              SizedBox(height: 15),
              Text(
                'Category: ${order['category'] ?? 'N/A'}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 15),
              Text(
                'Description:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                order['description'] ?? 'No description available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ==================== WALLET PAGE ====================
class WalletPage extends StatefulWidget {
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double _walletBalance = 125.50;
  final TextEditingController _chargeAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'charge',
      'amount': 50.0,
      'date': '2024-12-20',
      'description': 'Initial charge',
    },
    {
      'type': 'purchase',
      'amount': -30.0,
      'date': '2024-12-21',
      'description': 'Order #1234',
    },
    {
      'type': 'charge',
      'amount': 100.0,
      'date': '2024-12-22',
      'description': 'Wallet top-up',
    },
  ];

  void _chargeWallet() {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_chargeAmountController.text);

      setState(() {
        _walletBalance += amount;
        _transactions.insert(0, {
          'type': 'charge',
          'amount': amount,
          'date': '2024-12-23',
          'description': 'Wallet charge',
        });
      });

      _chargeAmountController.clear();

      Fluttertoast.showToast(
        msg: '✅ Wallet charged successfully! +\$${amount.toStringAsFixed(2)}',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFfdfbfb), Color(0xFFebedee)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with Balance
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'My Wallet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // Balance Card
                  Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Available Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _walletBalance.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Charge Section
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF667eea),
                                          Color(0xFF764ba2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Charge Wallet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _chargeAmountController,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Amount',
                                  hintText: 'Enter amount to charge',
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: Color(0xFF667eea),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Color(0xFF667eea),
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter amount';
                                  }
                                  final amount = double.tryParse(value);
                                  if (amount == null || amount <= 0) {
                                    return 'Please enter a valid amount';
                                  }
                                  if (amount > 1000) {
                                    return 'Maximum charge amount is \$1000';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  _buildQuickAmount(10),
                                  SizedBox(width: 10),
                                  _buildQuickAmount(25),
                                  SizedBox(width: 10),
                                  _buildQuickAmount(50),
                                  SizedBox(width: 10),
                                  _buildQuickAmount(100),
                                ],
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _chargeWallet,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF667eea),
                                          Color(0xFF764ba2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_card,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Charge Now',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Transaction History Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Icon(Icons.history, color: Color(0xFF667eea)),
                          SizedBox(width: 8),
                          Text(
                            'Transaction History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),

                    // Transaction List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        return _buildTransactionItem(_transactions[index]);
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmount(int amount) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _chargeAmountController.text = amount.toString();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF667eea).withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF667eea).withOpacity(0.05),
          ),
          child: Text(
            '\$$amount',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    bool isCharge = transaction['type'] == 'charge';
    double amount = transaction['amount'];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCharge
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCharge ? Icons.arrow_downward : Icons.arrow_upward,
              color: isCharge ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  transaction['date'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '${amount >= 0 ? '+' : ''}\$${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCharge ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chargeAmountController.dispose();
    super.dispose();
  }
}

// ==================== SETTINGS PAGE ====================
class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String _selectedFont = 'Default';
  String _selectedLanguage = 'English';
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFfdfbfb), Color(0xFFebedee)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.white, size: 32),
                  SizedBox(width: 15),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Settings List
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  // Theme Settings
                  _buildSettingCard(
                    title: 'Appearance',
                    icon: Icons.palette,
                    children: [
                      SwitchListTile(
                        title: Text('Dark Mode'),
                        subtitle: Text('Enable dark theme'),
                        value: _isDarkMode,
                        activeColor: Color(0xFF667eea),
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });
                          Fluttertoast.showToast(
                            msg: _isDarkMode
                                ? 'Dark mode enabled'
                                : 'Light mode enabled',
                            backgroundColor: Color(0xFF667eea),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Font Style'),
                        subtitle: Text(_selectedFont),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () => _showFontPicker(),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  // Language Settings
                  _buildSettingCard(
                    title: 'Language',
                    icon: Icons.language,
                    children: [
                      ListTile(
                        title: Text('App Language'),
                        subtitle: Text(_selectedLanguage),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () => _showLanguagePicker(),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  // Notification Settings
                  _buildSettingCard(
                    title: 'Notifications',
                    icon: Icons.notifications,
                    children: [
                      SwitchListTile(
                        title: Text('Push Notifications'),
                        subtitle: Text('Receive order updates'),
                        value: _notifications,
                        activeColor: Color(0xFF667eea),
                        onChanged: (value) {
                          setState(() {
                            _notifications = value;
                          });
                          Fluttertoast.showToast(
                            msg: _notifications
                                ? 'Notifications enabled'
                                : 'Notifications disabled',
                            backgroundColor: Color(0xFF667eea),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  // Account Settings
                  _buildSettingCard(
                    title: 'Account',
                    icon: Icons.account_circle,
                    children: [
                      ListTile(
                        leading: Icon(Icons.lock, color: Color(0xFF667eea)),
                        title: Text('Change Password'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: 'Password change requested',
                            backgroundColor: Color(0xFF667eea),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        trailing: Icon(Icons.chevron_right, color: Colors.red),
                        onTap: () {
                          _showLogoutDialog();
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // App Info
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'App Version',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '1.0.0',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  void _showFontPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Font',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...['Default', 'Roboto', 'Open Sans', 'Lato', 'Montserrat']
                .map(
                  (font) => ListTile(
                    title: Text(font),
                    trailing: _selectedFont == font
                        ? Icon(Icons.check, color: Color(0xFF667eea))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedFont = font;
                      });
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: 'Font changed to $font',
                        backgroundColor: Color(0xFF667eea),
                      );
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...['English', 'Persian', 'Arabic', 'Spanish', 'French']
                .map(
                  (lang) => ListTile(
                    title: Text(lang),
                    trailing: _selectedLanguage == lang
                        ? Icon(Icons.check, color: Color(0xFF667eea))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedLanguage = lang;
                      });
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: 'Language changed to $lang',
                        backgroundColor: Color(0xFF667eea),
                      );
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Logged out successfully',
                backgroundColor: Colors.red,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
