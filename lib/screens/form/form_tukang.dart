import 'package:flutter/material.dart';
import '../content/home_screen.dart';

class FormTukang extends StatefulWidget {
  const FormTukang({super.key});

  @override
  State<FormTukang> createState() => _FormTukangState();
}

class _FormTukangState extends State<FormTukang> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  String _selectedCategory = '';
  String _selectedSubCategory = '';
  bool _ktpImageSelected = false;
  bool _showSubCategory = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Fixed category structure
  final Map<String, List<String>> _categories = {
    'Tukang Bangunan': [
      'Tukang Batu',
      'Tukang Kayu', 
      'Tukang Besi',
      'Tukang Atap'
    ],
    'Tukang Elektronik': [
      'Tukang AC',
      'Tukang Kulkas/Mesin Cuci',
      'Tukang Listrik',
      'Tukang TV/Radio'
    ],
    'Tukang Cat': [
      'Cat Tembok',
      'Cat Kayu',
      'Cat Besi',
      'Cat Dekoratif'
    ],
    'Tukang Cleaning Service': [
      'Cleaning Rumah',
      'Cleaning Kantor',
      'Cleaning Karpet',
      'Cleaning AC'
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_ktpImageSelected) {
        _showSnackBar('Mohon upload foto KTP terlebih dahulu', Colors.orange);
        return;
      }
      
      // Show success animation
      _showSnackBar('Data berhasil disubmit!', Colors.green);
      
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      });
    } else {
      _showSnackBar('Mohon lengkapi semua field yang diperlukan', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : 
              color == Colors.orange ? Icons.warning : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickKTPImage() async {
    setState(() {
      _ktpImageSelected = true;
    });
    
    _showSnackBar('Foto KTP berhasil dipilih', Colors.green);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 17)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF3B950),
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _birthDateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool isDateField = false,
    double width = 286,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Acme',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: width,
            constraints: const BoxConstraints(minHeight: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF3B950).withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
              border: Border.all(
                color: const Color(0xFFF3B950).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              readOnly: isDateField,
              onTap: isDateField ? _selectDate : null,
              style: const TextStyle(
                fontFamily: 'Abel',
                fontSize: 14,
                color: Color(0xFF2C2C2C),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontFamily: 'Abel',
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                suffixIcon: isDateField ? 
                  const Icon(Icons.calendar_today, 
                    color: Color(0xFFF3B950), size: 20) : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hintText,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Acme',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 286,
            constraints: const BoxConstraints(minHeight: 50),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF3B950).withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
              border: Border.all(
                color: const Color(0xFFF3B950).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: value?.isEmpty == true ? null : value,
              validator: validator,
              hint: Text(
                hintText,
                style: const TextStyle(
                  fontFamily: 'Abel',
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, 
                color: Color(0xFFF3B950)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              dropdownColor: Colors.white,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                             MediaQuery.of(context).padding.top - 
                             MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Enhanced Header
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFF3B950),
                                Color(0xFFE8A63C),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                              bottomRight: Radius.circular(100),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF3B950).withOpacity(0.4),
                                offset: const Offset(0, 8),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(40, 40, 40, 60),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.verified_user,
                                size: 40,
                                color: Colors.black87,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'VERIFIKASI\nTUKANG',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Koulen',
                                  fontSize: 32,
                                  height: 1.1,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 3,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Form Content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                
                                // Enhanced description
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFF3B950).withOpacity(0.3),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.info_outline, 
                                        color: Color(0xFFF3B950), size: 20),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Isi data dengan benar untuk mempermudah verifikasi dan mempublikasikan profil tukang Anda.',
                                          style: TextStyle(
                                            fontFamily: 'Alata',
                                            fontSize: 12,
                                            height: 1.4,
                                            color: Color(0xFF2C2C2C),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Form Fields
                                _buildInputField(
                                  label: 'Nama Lengkap',
                                  controller: _nameController,
                                  hintText: 'Masukkan nama lengkap Anda',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Nama tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                _buildInputField(
                                  label: 'Alamat Lengkap',
                                  controller: _addressController,
                                  hintText: 'Masukkan alamat lengkap Anda',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Alamat tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Birth Place and Date Row
                                const Text(
                                  'Tempat & Tanggal Lahir',
                                  style: TextStyle(
                                    fontFamily: 'Acme',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C2C2C),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInputField(
                                        label: '',
                                        controller: _birthPlaceController,
                                        hintText: 'Tempat Lahir',
                                        width: double.infinity,
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'Wajib diisi';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInputField(
                                        label: '',
                                        controller: _birthDateController,
                                        hintText: 'Pilih Tanggal',
                                        width: double.infinity,
                                        isDateField: true,
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'Wajib diisi';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Category Dropdown
                                _buildDropdownField(
                                  label: 'Kategori Keahlian',
                                  value: _selectedCategory,
                                  items: _categories.keys.toList(),
                                  hintText: 'Pilih kategori keahlian',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Pilih kategori keahlian';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value!;
                                      _selectedSubCategory = '';
                                      _showSubCategory = _categories[value]!.isNotEmpty;
                                    });
                                  },
                                ),

                                // Animated Sub-category Dropdown
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOutCubic,
                                  child: _showSubCategory ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 16),
                                      _buildDropdownField(
                                        label: 'Spesialisasi',
                                        value: _selectedSubCategory,
                                        items: _categories[_selectedCategory] ?? [],
                                        hintText: 'Pilih spesialisasi Anda',
                                        validator: (value) {
                                          if (_showSubCategory && (value == null || value.isEmpty)) {
                                            return 'Pilih spesialisasi';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedSubCategory = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ) : const SizedBox.shrink(),
                                ),
                                const SizedBox(height: 16),

                                // Enhanced KTP Upload
                                const Text(
                                  'Foto KTP',
                                  style: TextStyle(
                                    fontFamily: 'Acme',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C2C2C),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _pickKTPImage,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: double.infinity,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: _ktpImageSelected 
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _ktpImageSelected 
                                            ? Colors.green
                                            : const Color(0xFFF3B950).withOpacity(0.3),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _ktpImageSelected
                                              ? Colors.green.withOpacity(0.2)
                                              : const Color(0xFFF3B950).withOpacity(0.1),
                                          offset: const Offset(0, 4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: _ktpImageSelected
                                        ? const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check_circle_rounded, 
                                                   color: Colors.green, size: 28),
                                              SizedBox(width: 12),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('KTP Berhasil Dipilih', 
                                                       style: TextStyle(
                                                         fontSize: 14, 
                                                         fontWeight: FontWeight.w600,
                                                         color: Colors.green
                                                       )),
                                                  Text('Tap untuk mengganti foto',
                                                       style: TextStyle(
                                                         fontSize: 11, 
                                                         color: Colors.green
                                                       )),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_a_photo_outlined, 
                                                   size: 28, 
                                                   color: const Color(0xFFF3B950).withOpacity(0.7)),
                                              const SizedBox(width: 12),
                                              const Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Upload Foto KTP', 
                                                       style: TextStyle(
                                                         fontSize: 14, 
                                                         fontWeight: FontWeight.w600,
                                                         color: Color(0xFF2C2C2C)
                                                       )),
                                                  Text('Tap untuk memilih foto',
                                                       style: TextStyle(
                                                         fontSize: 11, 
                                                         color: Color(0xFF999999)
                                                       )),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 24),
                                
                                // Enhanced Submit Button
                                Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFF4B951), Color(0xFFE8A63C)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFF4B951).withOpacity(0.4),
                                          offset: const Offset(0, 8),
                                          blurRadius: 16,
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(28),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.send_rounded, 
                                               color: Colors.black87, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'KIRIM DATA',
                                            style: TextStyle(
                                              fontFamily: 'Acme',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}