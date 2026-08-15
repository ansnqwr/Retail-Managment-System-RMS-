import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/data/models/Repository/signup_repository.dart';
import '/features/auth/view/SignupScreen.dart'; // for LocationItem
import '../view_model/bloc/login_bloc.dart';

class GoogleDataCollectionScreen extends StatefulWidget {
  final String email;
  final String googleId;

  const GoogleDataCollectionScreen({
    super.key,
    required this.email,
    required this.googleId,
  });

  @override
  State<GoogleDataCollectionScreen> createState() =>
      _GoogleDataCollectionScreenState();
}

class _GoogleDataCollectionScreenState
    extends State<GoogleDataCollectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  List<LocationItem> _governorates = [];
  List<LocationItem> _cities = [];
  int? _selectedGovernorateId;
  String? _selectedGovernorateName;
  int? _selectedCityId;
  String? _selectedCityName;
  bool _isLoadingGovs = true;
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    _loadGovernorates();
  }

  Future<void> _loadGovernorates() async {
    try {
      final repo = SignupRepository();
      final list = await repo.getGovernorates();
      setState(() {
        _governorates = list;
        _isLoadingGovs = false;
      });
    } catch (e) {
      setState(() => _isLoadingGovs = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _loadCities(int govId) async {
    setState(() {
      _isLoadingCities = true;
      _cities = [];
      _selectedCityId = null;
      _selectedCityName = null;
    });
    try {
      final repo = SignupRepository();
      final list = await repo.getCities(govId);
      setState(() {
        _cities = list;
        _isLoadingCities = false;
      });
    } catch (e) {
      setState(() => _isLoadingCities = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkPurple = Color(0xFF6B2D5C);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Complete Profile",
          style: TextStyle(color: darkPurple, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: darkPurple),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF2A488)),
                  ),
            );
          }
          if (state is LoginFailure) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(state.error),
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We need a few more details\nto finish your Google sign-in.",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFF2A488),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildField("First Name", _firstCtrl, Icons.person_outline),
                  _buildField("Last Name", _lastCtrl, Icons.person_outline),
                  _buildField("Phone Number", _phoneCtrl, Icons.phone_outlined),
                  const SizedBox(height: 8),
                  if (_isLoadingGovs)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildDropdown(
                      "Governorate",
                      _governorates,
                      _selectedGovernorateId,
                      (val) {
                        setState(() {
                          _selectedGovernorateId = val;
                          _selectedCityId = null;
                          _selectedCityName = null;
                          _cities = [];
                          if (val != null) {
                            _selectedGovernorateName =
                                _governorates
                                    .firstWhere((g) => g.id == val)
                                    .name;
                          }
                        });
                        if (val != null) _loadCities(val);
                      },
                    ),
                  const SizedBox(height: 16),
                  if (_isLoadingCities)
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDED3DC).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: darkPurple,
                            strokeWidth: 2.5,
                          ),
                        ),
                      ),
                    )
                  else
                    _buildDropdown("City", _cities, _selectedCityId, (val) {
                      setState(() {
                        _selectedCityId = val;
                        if (val != null) {
                          _selectedCityName =
                              _cities.firstWhere((c) => c.id == val).name;
                        }
                      });
                    }),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkPurple,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(
                          SubmitGoogleSignInDataEvent(
                            email: widget.email,
                            googleId: widget.googleId,
                            firstName: _firstCtrl.text.trim(),
                            lastName: _lastCtrl.text.trim(),
                            phone: _phoneCtrl.text.trim(),
                            governorate: _selectedGovernorateName ?? '',
                            city: _selectedCityName ?? '',
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Color(0xFFF2A488),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B2D5C),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          validator:
              (val) => (val == null || val.isEmpty) ? 'Field required' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFDED3DC).withOpacity(0.4),
            prefixIcon: Icon(icon, color: const Color(0xFF6B2D5C)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<LocationItem> items,
    int? value,
    Function(int?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B2D5C),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          isExpanded: true,
          value: value,
          hint: Text('Select $label'),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item.id,
                      child: Text(item.name, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFDED3DC).withOpacity(0.4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (val) => val == null ? 'Select $label' : null,
        ),
      ],
    );
  }
}
