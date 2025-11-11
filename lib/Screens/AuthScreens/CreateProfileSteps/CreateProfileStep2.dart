import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../Controllers/Auth/CreateProfileController.dart';
import '../../../main.dart';

class CreateProfileStep2 extends StatelessWidget {
  final CreateProfileController controller;

  const CreateProfileStep2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: controller.selectedStep == 1
          ? Form(
        key: controller.createProfileFormKeys[1],
        child: Center(
          child: SizedBox(
            width: 90.w,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 3.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF971D),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 6.h,
                                width: 100.w,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      " Write Your Bank Details Here!",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '* ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'All fields are mandatory',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Account Holder Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: controller.bankAccountHolderNameEditingController,
                            textCapitalization: TextCapitalization.characters,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Enter account holder name here',
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            maxLength: 30,
                            validator: (value) => utils.validateText(
                              string: value.toString(),
                              required: true,
                            ),
                            onChanged: (newbankAccountHolderName) =>
                                controller.updatebankAccountHolderNameTxt(newbankAccountHolderName),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Account Number',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.bankAccountHolderAcNumberController,
                            textCapitalization: TextCapitalization.characters,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Enter account number here',
                              labelText: 'Enter account number',
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            maxLength: 18,
                            validator: (value) => utils.validateBankAccountNumber(
                                value.toString(),
                                controller.bankAccountHolderAc1NumberController.text),
                            onChanged: (newbankAccountHolderAcNumber) =>
                                controller.updatebankAccountHolderAcNumberTxt(newbankAccountHolderAcNumber),
                            obscureText: true,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Re Enter Account Number',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.bankAccountHolderAc1NumberController,
                            textCapitalization: TextCapitalization.characters,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Re-Enter Your Bank account Number',
                              labelText: 'Re-Enter Your Bank account Number',
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            maxLength: 18,
                            validator: (value) => utils.validateBankAccountNumber(
                                controller.bankAccountHolderAcNumberController.text,
                                value.toString()),
                            onChanged: (newbankAccountHolderAc1Number) =>
                                controller.updatebankAccountHolderAc1NumberTxt(newbankAccountHolderAc1Number),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Enter account IFSC Code here',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.bankAccountHolderIFSCController,
                            textCapitalization: TextCapitalization.characters,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Enter account IFSC Code here',
                              labelText: 'Enter account IFSC code',
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            maxLength: 11,
                            validator: (value) => utils.validateBankIFSCCode(
                                value.toString(),
                                controller.bankAccountHolderIFSC1Controller.text),
                            onChanged: (newbankAccountHolderIFSC) =>
                                controller.updatebankAccountHolderIFSCTxt(newbankAccountHolderIFSC),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Re Enter IFSC Code Number',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.bankAccountHolderIFSC1Controller,
                            textCapitalization: TextCapitalization.characters,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Re-Enter Your IFSC Code',
                              labelText: 'Re-Enter Your IFSC Code',
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            maxLength: 11,
                            validator: (value) => utils.validateBankIFSCCode(
                                controller.bankAccountHolderIFSCController.text,
                                value.toString()),
                            onChanged: (newbankAccountHolderIFSC1) =>
                                controller.updatebankAccountHolderIFSC1Txt(newbankAccountHolderIFSC1),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Enter bank name here',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controller.bankAccountHolderBankNameController,
                            textCapitalization: TextCapitalization.characters,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Enter bank name here',
                              labelText: 'Enter bank name here',
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            maxLength: 18,
                            validator: (value) => utils.validateText(
                              string: value.toString(),
                              required: true,
                            ),
                            onChanged: (newbankAccountHolderBankName) =>
                                controller.updatebankAccountHolderBankBranchTxt(newbankAccountHolderBankName),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          : Container(),
    );
  }
}
