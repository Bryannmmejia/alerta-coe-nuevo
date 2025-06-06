import 'package:alertacoe/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// <-- This import is correct for DropdownSearch widget
// Make sure you have the correct package version in pubspec.yaml

class MyWidgets {
  static final MyWidgets _instance = MyWidgets._internal();

  factory MyWidgets() {
    return _instance;
  }

  MyWidgets._internal();

  Widget entryField(
    String title,
    TextEditingController controller,
    TextInputType type,
    BuildContext context,
    Icon icon, {
    bool isPassword = false,
    double lessWidth = 20,
    int? maxLength,
    FocusNode? focusNode,
    bool passwordVisible = false,
    Function? fnShowPassword,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width - lessWidth,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            obscureText: isPassword ? !passwordVisible : false,
            maxLength: maxLength,
            keyboardType: type,
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: title,
              filled: true,
              prefixIcon: icon,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        if (fnShowPassword != null) fnShowPassword();
                      },
                    )
                  : null,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue[900]!),
                borderRadius: BorderRadius.circular(15.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
          )
        ],
      ),
    );
  }

  InkWell submitButton(BuildContext context, String text, Function submit) {
    return InkWell(
      onTap: () => submit(),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [kPrimaryColor, kPrimaryColor, blue_logo_coe])),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget backButton(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text(text,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  void onLoading(BuildContext context, [String? text]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 90,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(),
                Text(
                  "${text ?? "Espere"}...",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget myDropDown(BuildContext context, String searchText, dynamic selectItem,
      List<DropdownMenuItem> items, Function onSelectedIndexChange) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          border: Border.all(color: Colors.grey)),
      child: DropdownButton<dynamic>(
          value: selectItem,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 42,
          isExpanded: true,
          underline: SizedBox(),
          hint: Text(searchText),
          onChanged: (dynamic value) => onSelectedIndexChange(value),
          items: items),
    );
  }

  Widget myDropDown2(BuildContext context, String searchText, dynamic selectItem,
      List<DropdownMenuItem> items, Function onSelectedIndexChange) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: DropdownButton<dynamic>(
              value: selectItem,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 42,
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(searchText),
              onChanged: (dynamic value) => onSelectedIndexChange(value),
              items: items),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }


  Widget divider(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(text,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget simpleButton(BuildContext context, String text, Function submit) {
    return SizedBox(
      height: 35,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.green, backgroundColor: Colors.green[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        child: Text(text,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        onPressed: () => submit(),
      ),
    );
  }

  Widget addItemButton(BuildContext context, String text, Function submit) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        child: Text(text,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400)),
        onPressed: () => submit(),
      ),
    );
  }

  Widget appName(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Alerta ',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'C',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            TextSpan(
              text: 'OE',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  Widget facebookButton(Function submit) {
    return InkWell(
      onTap: () => submit(),
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff1959a9),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('f',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff2872ba),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('Log in with Facebook',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final logo = Padding(
      padding: EdgeInsets.all(0),
      child: Hero(
          tag: 'hero',
          child: CircleAvatar(
              radius: 100.0,
              child: Image.asset('assets/images/google-icon.png'),
              backgroundColor: Colors.transparent)));

  Widget gmailButton(Function submit, String text) {
    return InkWell(
      onTap: () => submit(),
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Container(
              height: 30,
              child: Image.asset('assets/images/google-icon.png'),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAlertDialog(
      BuildContext context, Function fnYes, Function fnNo, String text) {
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
        fnNo();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Si"),
      onPressed: () {
        Navigator.pop(context);
        fnYes();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Confirmación"),
      content: Text(text),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
