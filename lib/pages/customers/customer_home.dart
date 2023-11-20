import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/models/LocationModel.dart';
import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:easylygo_app/pages/customers/customer_payment_activities.dart';
import 'package:easylygo_app/pages/customers/customer_home_page.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/place_service.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:easylygo_app/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';

class CustomerHomePage extends ConsumerStatefulWidget {
  const CustomerHomePage({super.key});

  @override
  ConsumerState<CustomerHomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<CustomerHomePage> {
  int index = 0;

  List<Widget> pages = [CustomerHomeActivities(), CustomerPaymentPage()];

  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    //_loadCUrrentLocation();
    // LocationUtil.getCurrentLocationData().then((locationData) => {
    //   PlaceService.getInitlaAddress(locationData!).then((value) => {
    //     print("Hellllloooooo there++++++<<<<<<+++++++@@@@@@@@@@@@@@@$value")
     
    //   }).catchError((error){
    //     print("Errorrr========<<<<<<<>>>>>>>$error");
      
    //     })
    // });
  }

  Future<void> _loadCUrrentLocation() async {
    print("Hello=========<<<<<<>>>>>>>>>>>");
    LocationData? locationData = await LocationUtil.getCurrentLocationData();
    PlaceModel? placeModel = await PlaceService.getInitlaAddress(locationData!);
    print('=======>>>>Place model<<<<<<<<>>>>$placeModel');
    // ref.read(currentLocationProvider).placeCoordnates =
    //     placeModel!.placeCoordnates;
    // ref.read(currentLocationProvider).placeId = placeModel.placeId;
    // ref.read(currentLocationProvider).placeDescription =
    //     placeModel.placeDescription;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easily go'),
        elevation: 1,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                index = 0;
              });
            },
            child: Icon(Icons.refresh),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ClipOval(
                              child: Image.asset(
                            'assets/images/user_avatar.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )),
                          Text(
                            user.fullName.toString(),
                            style: textStyleTitle(13),
                          )
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Text(onLineStatus),
                      //     Switch(
                      //       trackColor: MaterialStateProperty.all(
                      //           const Color.fromARGB(96, 234, 234, 234)),
                      //       activeColor:
                      //           Color.fromARGB(255, 2, 170, 7).withOpacity(0.4),
                      //       inactiveThumbColor: Color.fromARGB(255, 201, 111, 42)
                      //           .withOpacity(0.4),
                      //       value: userModel.status=='active'? true:false,
                      //       onChanged: onChanged,
                      //     )
                      //   ],
                      // )
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              iconColor: AppColors.mainColor,
              textColor: AppColors.mainColor,
              leading: const Icon(
                FontAwesomeIcons.map,
                size: 25,
              ),
              title: const Text('My trip requests'),
              onTap: () {
                Navigator.pushNamed(context, CUSTOMER_TRIP_REQUEST);
              },
            ),
            ListTile(
              iconColor: AppColors.mainColor,
              textColor: AppColors.mainColor,
              leading: const Icon(
                FontAwesomeIcons.road,
                size: 25,
              ),
              title: const Text('Posted journeys'),
              onTap: () {
                Navigator.pushNamed(context, CUSTOMER_POSTED_JOURNEYS);
              },
            ),
            ListTile(
              iconColor: AppColors.mainColor,
              textColor: AppColors.mainColor,
              leading: const Icon(
                FontAwesomeIcons.wallet,
                size: 25,
              ),
              title: const Text('Payment'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              iconColor: AppColors.mainColor,
              textColor: AppColors.mainColor,
              leading: const Icon(
                Icons.account_box,
                size: 25,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              iconColor: AppColors.mainColor,
              textColor: AppColors.mainColor,
              leading: const Icon(
                Icons.logout,
                size: 25,
              ),
              title: const Text('Logout'),
              onTap: () async {
                await UserService.signOut();
                Navigator.pushReplacementNamed(context, GET_STARTED);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: pages[index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.moneyBill), label: "Payment")
        ],
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        currentIndex: index,
        selectedItemColor: AppColors.mainColor,
      ),
    );
  }
}
