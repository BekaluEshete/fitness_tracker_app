import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/view/login/what_your_goal_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  DateTime? _selectedDate;
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  String? selectedGender;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        txtDate.text = DateFormat('yyyy-MM-dd')
            .format(_selectedDate!); // Formatting the date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: media.width * 0.05),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(height: media.width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      // Gender Selection Dropdown
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.lightGray,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Image.asset(
                                "assets/img/gender.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                color: TColor.gray,
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedGender,
                                  items: ["Male", "Female", "Other"]
                                      .map((name) => DropdownMenuItem(
                                            value: name,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  color: TColor.gray,
                                                  fontSize: 14),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                  isExpanded: true,
                                  hint: Text(
                                    "Choose Gender",
                                    style: TextStyle(
                                        color: TColor.gray, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      SizedBox(height: media.width * 0.04),

                      // Date of Birth Input (Standard TextField with onTap and readOnly)
                      Container(
                        decoration: BoxDecoration(
                          color: TColor.lightGray,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: txtDate,
                          decoration: const InputDecoration(
                            hintText: "Date of Birth",
                            prefixIcon: Icon(Icons.calendar_today),
                            border: InputBorder.none,
                          ),
                          readOnly: true, // Disable manual input
                          onTap: () {
                            _selectDate(context); // Open date picker on tap
                          },
                        ),
                      ),
                      SizedBox(height: media.width * 0.04),

                      // Weight Input
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: txtWeight,
                              hitText: "Your Weight",
                              icon: "assets/img/weight.png",
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient:
                                  LinearGradient(colors: TColor.secondaryG),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.04),

                      // Height Input
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: txtHeight,
                              hitText: "Your Height",
                              icon: "assets/img/hight.png",
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient:
                                  LinearGradient(colors: TColor.secondaryG),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "CM",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.07),

                      // Next Button to store data and navigate
                      RoundButton(
                        title: "Next >",
                        onPressed: () async {
                          try {
                            User? user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await _firestore
                                  .collection("userdata")
                                  .doc(user.uid)
                                  .set({
                                'gender': selectedGender,
                                'date_of_birth': txtDate.text,
                                'weight': txtWeight.text,
                                'height': txtHeight.text,
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const WhatYourGoalView(),
                                ),
                              );
                            }
                          } catch (e) {
                            print("Error saving data: $e");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
