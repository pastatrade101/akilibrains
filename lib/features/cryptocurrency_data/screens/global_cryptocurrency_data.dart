import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:trade101/common/widgets/shimmer/shimmer_effect.dart';
import 'package:trade101/features/cryptocurrency_data/screens/pdi_view.dart';
import 'package:trade101/features/cryptocurrency_data/screens/pivot_searchable_widget.dart';
import 'package:trade101/features/cryptocurrency_data/screens/pivots_view.dart';
import 'package:trade101/features/cryptocurrency_data/screens/rsi_view.dart';
import 'package:trade101/features/cryptocurrency_data/screens/fibonacci_searchable_widget.dart';
import 'package:trade101/features/cryptocurrency_data/screens/subscription_form.dart';
import 'package:trade101/features/cryptocurrency_data/screens/supertrend_view.dart';
import 'package:trade101/features/cryptocurrency_data/screens/token_rsi.dart';
import 'package:trade101/home_menu.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/texts/section_heading.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

import '../controller/cmf_controller.dart';
import '../controller/dmi_controller.dart';
import '../controller/global_crypto_data_controller.dart';
import '../controller/pivots_controller.dart';
import '../controller/rsi_controller.dart';
import '../controller/subscription_controller.dart';
import '../controller/supertrend_controller.dart';


import 'cmf_average.dart';
import 'cmf_chart.dart';


import 'fibonacciretracement_view.dart';

class GlobalCryptoData extends StatelessWidget {
  final CryptoController cryptoController = Get.put(CryptoController());
  final DmiController dmiController = Get.put(DmiController());
  final RsiController rsiController = Get.put(RsiController());
  final CmfController cmfController = Get.put(CmfController());
  final SuperTrendController superTrendController = Get.put(SuperTrendController());
  final SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  GlobalCryptoData({super.key});

  String formatPrice(double price) {
    if (price >= 1e12) {
      return '${(price / 1e12).toStringAsFixed(2)}T';
    } else if (price >= 1e9) {
      return '${(price / 1e9).toStringAsFixed(2)}B';
    } else if (price >= 1e6) {
      return '${(price / 1e6).toStringAsFixed(2)}Mil';
    } else {
      return price.toStringAsFixed(2);
    }
  }

  String formatWithCommas(double value) {
    if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)}Mil';
    } else {
      return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }
  }

  @override
  Widget build(BuildContext context) {
    final PivotController pivotController = Get.put(PivotController());

    return Scaffold(
      appBar: TAppBar(
        color: THelperFunctions.isDarkMode(context)
            ? TColors.black
            : TColors.primaryBackground,
        centerTitle: true,
        title: const Text('Crypto Analytics'),
        padding: 0,
      ),
      body: SingleChildScrollView(
        child: subscriptionController.isSubscribed.value
            ? Obx(
                () => Padding(
                  padding: const EdgeInsets.only(
                      bottom: 100,
                      right: TSizes.defaultSpace - 12,
                      left: TSizes.defaultSpace - 12,
                      top: TSizes.defaultSpace),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Obx(() {
                    if (superTrendController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return SuperTrendWidget(responseData: superTrendController.responseData);
                    }
                  }),
                      const SizedBox(
                        height: TSizes.fontSizeSm,
                      ),




                      PdiWidget(
                        pdiValue: dmiController.pdi.value,
                        mdiValue: dmiController.mdi.value,
                      ),
                      const SizedBox(
                        height: TSizes.md ,
                      ),


                      RsiWidget(
                        rsiValue: rsiController.rsi.value,
                      ),
                      const SizedBox(
                        height: TSizes.md - 6,
                      ),


                      TRoundedContainer(
                        backgroundColor: THelperFunctions.isDarkMode(context)
                            ? TColors.light.withOpacity(0.1)
                            : TColors.primary.withOpacity(0.1),
                        child: Column(
                          children: [
                            CmfAvgWidget(
                                cmfAvgValue:
                                    cmfController.cmfAverageValue.value),
                            const SizedBox(
                              height: TSizes.md - 6,
                            ),
                            TRoundedContainer(
                                backgroundColor:
                                    THelperFunctions.isDarkMode(context)
                                        ? TColors.black.withOpacity(0.2)
                                        : TColors.dark.withOpacity(0.2),
                                child: const CmfChart()),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.md - 6,
                      ),
                      TRoundedContainer(
                        padding: const EdgeInsets.symmetric(
                            vertical: TSizes.md, horizontal: TSizes.lg),
                        backgroundColor: THelperFunctions.isDarkMode(context)
                            ? TColors.light.withOpacity(0.1)
                            : TColors.light,
                        child: Column(
                          children: [
                            const TSectionHeading(
                                title: 'CMF indicator (Money Flow)',
                                showActionButton: false),
                            const SizedBox(
                              height: TSizes.md - 6,
                            ),
                            Text(
                              'Given the past 10 days data, the CMF indicator categorizes market sentiment into Buy, Sell, or Hold zones. A positive average CMF suggests a Buy zone, indicating potential accumulation opportunities, while a negative average CMF suggests a Sell zone, signaling potential distribution opportunities. The Hold zone, with CMF around zero, indicates a neutral market sentiment. These insights help you make timely decisions about your investments.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color:
                                          THelperFunctions.isDarkMode(context)
                                              ? TColors.light.withOpacity(0.7)
                                              : TColors.dark),
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.md - 6,
                      ),
                      const FibonacciRetracementWidget(
                        pair: 'INJ/USDT (4H)',
                      ),
                      const SizedBox(
                        height: TSizes.md - 6,
                      ),
                      TRoundedContainer(
                        backgroundColor: THelperFunctions.isDarkMode(context)
                            ? TColors.dark
                            : TColors.dark,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Obx(
                          () => pivotController.isLoading.value
                              ? const TShimmerEffect(
                                  width: double.infinity, height: 200)
                              : Column(
                                  children: [
                                    const TSectionHeading(
                                        title: 'Support & Resistance',textColor: TColors.white,
                                        showActionButton: false),const SizedBox(height: 16,),
                                    Row(
                                      children: [SizedBox(width: 120, child: PivotPairSelectionWidgetCrypto(controller: pivotController,)),

                                        const SizedBox(
                                          width: TSizes.md,
                                        ),
                                        const PivotTimeSelectionWidget()
                                      ],
                                    ),const SizedBox(height: 16,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            PivotPointCard(
                                                label: 'Resistance 1',
                                                value: pivotController
                                                    .pivotPoints
                                                    .value
                                                    .resistance1),
                                            PivotPointCard(
                                                label: 'Resistance 2',
                                                value: pivotController
                                                    .pivotPoints
                                                    .value
                                                    .resistance2),
                                            PivotPointCard(
                                                label: 'Resistance 3',
                                                value: pivotController
                                                    .pivotPoints
                                                    .value
                                                    .resistance3),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            PivotPointCard(
                                                label: 'Support 1',
                                                value: pivotController
                                                    .pivotPoints
                                                    .value
                                                    .support1),
                                            PivotPointCard(
                                                label: 'Support 2',
                                                value: pivotController
                                                    .pivotPoints
                                                    .value
                                                    .support2),
                                            PivotPointCard(
                                                label: 'Support 3',
                                                value: pivotController
                                                    .pivotPoints
                                                    .value
                                                    .support3),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TRoundedContainer(
                                        backgroundColor:
                                            THelperFunctions.isDarkMode(context)
                                                ? TColors.black.withOpacity(0.5)
                                                : TColors.black.withOpacity(0.5),
                                        child: PivotPointCard(
                                            label: 'Pivot Point (P)',
                                            value: pivotController
                                                .pivotPoints.value.pivot),
                                      ),
                                    ),

                                  ],
                                ),
                        ),
                      )
                    ].animate(interval: 100.ms).fadeIn(duration: 200.ms),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TRoundedContainer(
                        padding: const EdgeInsets.symmetric(
                            vertical: TSizes.md, horizontal: TSizes.lg),
                        backgroundColor: THelperFunctions.isDarkMode(context)
                            ? TColors.light.withOpacity(0.1)
                            : TColors.light,
                        child: Column(
                          children: [
                            const Text(
                              'Unlock Early Access!',
                              style: TextStyle(
                                  fontSize: 20, color: TColors.accent),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Text(
                              'Calling all Crypto Traders! Get ahead of the game with our exclusive feature. Simply Fill the form below and secure your spot for early access. Dive into our advanced insights and stay ahead of the market trends. Subscribe now and be among the first to experience it all! ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color:
                                          THelperFunctions.isDarkMode(context)
                                              ? TColors.light.withOpacity(0.7)
                                              : TColors.dark),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 14,
                    ),
                    TRoundedContainer(
                        padding: const EdgeInsets.symmetric(
                            vertical: TSizes.md, horizontal: TSizes.lg),
                        backgroundColor: THelperFunctions.isDarkMode(context)
                            ? TColors.light.withOpacity(0.1)
                            : TColors.light,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 14,
                            ),
                            Text(
                              'Plus, discover the power of real-time data from Binance Futures—home to 50+ pairs! Tap into this wealth of information to inform your spot buys or make quick trades for instant profits. Don\'t miss out on this signal for success!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color:
                                          THelperFunctions.isDarkMode(context)
                                              ? TColors.light.withOpacity(0.7)
                                              : TColors.dark),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    const SizedBox(
                        width: double.infinity,
                        child: TRoundedContainer(
                          backgroundColor: TColors.primary,
                          child: Text(
                            'The Relative Strength Index (RSI)',
                            style:
                                TextStyle(fontSize: 16, color: TColors.light),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    const SizedBox(
                        width: double.infinity,
                        child: TRoundedContainer(
                          backgroundColor: TColors.primary,
                          child: Text(
                            'Fibonacci retracement levels',
                            style:
                                TextStyle(fontSize: 16, color: TColors.light),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    const SizedBox(
                        width: double.infinity,
                        child: TRoundedContainer(
                          backgroundColor: TColors.primary,
                          child: Text(
                            'Support & Resistance',
                            style:
                                TextStyle(fontSize: 16, color: TColors.light),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    const SizedBox(
                        width: double.infinity,
                        child: TRoundedContainer(
                          backgroundColor: TColors.primary,
                          child: Text(
                            'The Chaikin Money Flow (CMF)',
                            style:
                                TextStyle(fontSize: 16, color: TColors.light),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    SubscribePage(),
                    const SizedBox(
                      height: 24,
                    ),
                    const SizedBox(height: 100,)],
                ),
              ),
      ),
    );
  }
}

class BtcDominanceWidget extends StatelessWidget {
  const BtcDominanceWidget({
    super.key,
    required this.cryptoController,
    required this.btcDominance,
  });

  final CryptoController cryptoController;
  final String btcDominance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TRoundedContainer(
        padding:
            const EdgeInsets.symmetric(vertical: TSizes.md, horizontal: 16),
        backgroundColor: THelperFunctions.isDarkMode(context)
            ? TColors.light.withOpacity(0.1)
            : TColors.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BTC Dominance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${cryptoController.btcDominance.value.toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: THelperFunctions.isDarkMode(context)
                      ? TColors.complementary
                      : TColors.complementary),
            ),
          ],
        ),
      ),
    );
  }
}

class EthDominanceWidget extends StatelessWidget {
  const EthDominanceWidget({
    super.key,
    required this.cryptoController,
    required this.ethDominance,
  });

  final CryptoController cryptoController;
  final String ethDominance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TRoundedContainer(
        padding:
            const EdgeInsets.symmetric(vertical: TSizes.md, horizontal: 16),
        backgroundColor: THelperFunctions.isDarkMode(context)
            ? TColors.light.withOpacity(0.1)
            : TColors.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ETH Dominance:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              ethDominance,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: THelperFunctions.isDarkMode(context)
                      ? TColors.complementary
                      : TColors.complementary),
            ),
          ],
        ),
      ),
    );
  }
}
