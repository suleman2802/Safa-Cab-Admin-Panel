import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Routes/navigation_methods.dart';
import '../../../General Widgets/Responsive.dart';
import '../../../General Widgets/custom_card.dart';
import '../model/health_model.dart';

class ActivityDetailsCard extends StatelessWidget {
  const ActivityDetailsCard({super.key});

  final List<HealthModel> healthDetails = const [
    HealthModel(icon: 'assets/Icons/car.png', title: "Cars"),
    HealthModel(icon: 'assets/Icons/ziyarat.png', title: "Ziya-rats"),
    HealthModel(icon: 'assets/Icons/package.png', title: "Packages"),
    HealthModel(icon: 'assets/Icons/stats.png', title: "Stats"),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: healthDetails.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
          crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
          mainAxisSpacing: 12.0),
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () => {
            if(i == 0){
              navigateToCar(context),
            }
            else if (i == 1){
              navigateToZiyarat(context),
            }
            else if (i == 2){
                navigateToPackage(context),
              }
              else if (i == 3){
                  navigateToStats(context),
                }
          },
          child: CustomCard(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //SizedBox(height: 20,),
                  Image.asset(
                    healthDetails[i].icon,
                    width: !Responsive.isDesktop(context)? 50 : 80,
                    height:!Responsive.isDesktop(context)? 50 : 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 4),
                    child: Text(
                      healthDetails[i].title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: Responsive.isMobile(context)? 14:22,
                      ),
                    ),
                  ),
                  // SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
