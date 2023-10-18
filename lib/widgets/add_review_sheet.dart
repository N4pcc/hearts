import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:hearts/helpers/style.dart';
import 'package:hearts/providers/app_state.dart';
import '../helpers/methods.dart';
import 'hearts_button.dart';
import 'custom_text.dart';

class AddReviewSheet extends StatefulWidget {
  const AddReviewSheet({super.key});

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  double rating = 0;

  Future createPayment(String amount) async {
    try {
      setState(() {
        // isLoading = true;
      });
      // Map data = await StripeService().createPaymentIntent(amount);

      // await stripe.Stripe.instance.initPaymentSheet(
      //   paymentSheetParameters: stripe.SetupPaymentSheetParameters(
      //     paymentIntentClientSecret: data["client_secret"],
      //     merchantDisplayName: 'Taxi Taxi',
      //   ),
      // );
      // await stripe.Stripe.instance.presentPaymentSheet();
      // UserServices().updateUserProfile(
      //     {"isPremium": true, "premiumDate": DateTime.now()});
      setState(() {
        //   isLoading = false;
      });
      // showSnack(
      //     context: context,
      //     message: "Payment completed successfully",
      //     color: Colors.green);
      //_controllerCenter.play();
      return true;
    } catch (e) {
      showSnack(
          context: context,
          message: "Payment request failed/declined",
          color: Colors.red);
      setState(() {
        //  isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider userProvider = Provider.of<UserProvider>(context);
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: .6,
      builder: (BuildContext context, myscrollController) {
        return StatefulBuilder(builder: (context, ss) {
          return Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: grey.withOpacity(.8),
                      offset: const Offset(3, 2),
                      blurRadius: 7)
                ]),
            child: ListView(
              padding: EdgeInsets.zero,
              controller: myscrollController,
              children: [
                const Icon(
                  Icons.remove,
                  size: 40,
                  color: grey,
                ),
                Container(
                  color: white,
                  margin: const EdgeInsets.only(left: 0, bottom: 20),
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text("Arrived Hospital!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ),
                Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomText(
                        text: "Your Booking Total",
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: CustomText(
                        text:
                            "ETB${appState.rideRequestModel!.price.toStringAsFixed(2)}",
                        size: 22,
                        color: green,
                        weight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text("Kindly rate you Booking experience.",
                        style: TextStyle(
                          color: black,
                          fontSize: 16,
                        )),
                  ),
                ),
                Center(
                  child: RatingBar(
                      initialRating: 0,
                      minRating: 0,
                      glow: false,
                      direction: Axis.horizontal,
                      itemSize: 50,
                      unratedColor: const Color(0xFF9FA8B0),
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                          empty: const Icon(
                            Icons.star_border_outlined,
                            color: Colors.amber,
                          ),
                          half: const Icon(
                            Icons.star_half_outlined,
                            color: Colors.amber,
                          ),
                          full: const Icon(
                            Icons.star,
                            color: Colors.amber,
                          )),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                      onRatingUpdate: (r) {
                        rating = r;
                        ss(() {});
                        setState(() {});
                      }),
                ),
                // SizedBox(
                //   width: double.infinity,
                //   height: 68,
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.only(left: 20, right: 20, top: 20),
                //     child: CabButton(
                //       isLoading: false,
                //       func: () async {
                //         if (rating == 0) {
                //         } else {
                //           bool? res = await createPayment(
                //               appState.rideRequestModel!.price.toString());
                //           if (res == true) {
                //             appState.completeRequest("card", rating);
                //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //                 backgroundColor: Colors.greenAccent[700],
                //                 content: const Text(
                //                     "Payment Successful. Thank you for review!!")));
                //           }
                //         }
                //       },
                //       color: rating == 0 ? grey : null,
                //       text: "Pay Online & Finish Ride",
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: HeartsButton(
                      isLoading: false,
                      func: () async {
                        if (rating == 0) {
                        } else {
                          appState.completeRequest("cash", rating);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.greenAccent[700],
                              content:
                                  const Text("Thank you for you review!!")));
                        }
                      },
                      color: rating == 0 ? grey : null,
                      text: "Pay Cash & Finish Booking",
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
