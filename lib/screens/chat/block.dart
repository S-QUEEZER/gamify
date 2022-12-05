// ignore_for_file: override_on_non_overriding_member, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../provider/user_provider.dart';

class Block extends StatefulWidget {
  final String dateTime;
  final Color textColor;
  final DateTime formatDateTime;
  final Color headTextColor;
  final Color thumbColor;
  final Color backgroundColor;
  final Color trackColor;

  const Block(
      {Key? key,
      required this.dateTime,
      required this.textColor,
      required this.formatDateTime,
      required this.headTextColor,
      required this.thumbColor,
      required this.trackColor,
      required this.backgroundColor})
      : super(key: key);

  @override
  State<Block> createState() => _BlockState();
}

class _BlockState extends State<Block> {
  @override
  var serving_size_g = 0.0;
  var total_carbs = 0.0;
  var total_fat = 0.0;
  var totalCalorie = 0.0;
  final ScrollController _controllerOne = ScrollController();
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return SizedBox(
      height: 210.h,
      width: 177.w,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('healthData')
              .doc(user.uid)
              .collection(widget.dateTime)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.docs.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];

                        var servingSizeG =
                            snapshot.data!.docs[index]['serving_size_g'];
                        var tempstore = servingSizeG;
                        servingSizeG = null;
                        serving_size_g += tempstore;

                        var carbs =
                            double.parse(snapshot.data!.docs[index]['carbs']);
                        var tempcarbsstore = carbs;
                        carbs = 0.0;
                        total_carbs += tempcarbsstore;

                        var fat = double.parse(
                            snapshot.data!.docs[index]['fat_total_g']);
                        var tempfatstore = fat;
                        fat = 0.0;
                        total_fat += tempfatstore;

                        var totalCalories = double.parse(
                            snapshot.data!.docs[index]['calories']);
                        var tempCaloriesstore = totalCalories;
                        totalCalorie = 0.0;
                        totalCalorie += tempCaloriesstore;

                        return index == snapshot.data!.docs.length - 1
                            ? Container(
                                height: 210.h,
                                width: 177.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: widget.backgroundColor),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      scrollbarTheme: ScrollbarThemeData(
                                          radius: Radius.circular(13.r),
                                          trackColor: MaterialStateProperty.all(
                                              widget.trackColor),
                                          thumbColor: MaterialStateProperty.all(
                                              widget.thumbColor))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 11.0.w, top: 14.h, bottom: 14.h),
                                    child: Scrollbar(
                                      controller: _controllerOne,
                                      trackVisibility: true,
                                      thickness: 5.w,
                                      thumbVisibility: true,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 14.0.h,
                                            bottom: 14.0.h,
                                            left: 15.0.w),
                                        child: ListView(
                                          controller: _controllerOne,
                                          children: [
                                            Text(
                                              DateFormat('dd MMMM').format(
                                                  widget.formatDateTime),
                                              style: TextStyle(
                                                  color: widget.textColor,
                                                  fontFamily: 'Inter-Regular',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp),
                                            ),
                                            SizedBox(
                                              height: 13.h,
                                            ),
                                            Text(
                                              "Serving size",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: widget.headTextColor),
                                            ),
                                            Text(
                                              serving_size_g.toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: widget.textColor),
                                            ),
                                            SizedBox(
                                              height: 18.h,
                                            ),
                                            Text(
                                              "Carbs",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: widget.headTextColor),
                                            ),
                                            Text(
                                              '${total_carbs.toStringAsFixed(2)}g',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: widget.textColor),
                                            ),
                                            SizedBox(
                                              height: 18.h,
                                            ),
                                            Text(
                                              "Fat",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: widget.headTextColor),
                                            ),
                                            Text(
                                              '${total_fat.toStringAsFixed(2)}g',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: widget.textColor),
                                            ),
                                            SizedBox(
                                              height: 18.h,
                                            ),
                                            Text(
                                              "Calories",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: widget.headTextColor),
                                            ),
                                            Text(
                                              '${totalCalorie.toStringAsFixed(2)}g',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: widget.textColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      })
                  : Container(
                      height: 210.h,
                      width: 177.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: widget.backgroundColor),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              DateFormat('dd MMMM')
                                  .format(widget.formatDateTime),
                              style: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Inter-Regular',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 37.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'No food log added',
                                    style: TextStyle(
                                        color: widget.headTextColor,
                                        fontFamily: 'InterRegular',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 27.h,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 31.h,
                                    width: 76.w,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF08769),
                                        borderRadius:
                                            BorderRadius.circular(29.r)),
                                    child: Text(
                                      'ADD NOW',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
