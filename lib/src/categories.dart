import 'package:pepe_food/Counters/categoryProvider.dart';
import 'package:pepe_food/Models/categoryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../main.dart';


class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // int currentSelectedItem = 0;

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<NewsService>(context).categories;

    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, int index) {
            final cName = categories[index].name;
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      margin:
                          EdgeInsets.only(left: index == 0 ? 20 : 0, right: 20),
                      child: CategoryCArd(categories[index]),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    margin:
                        EdgeInsets.only(left: index == 0 ? 20 : 0, right: 20),
                    width: 90,
                    child: Row(
                      children: [
                        Spacer(),
                        Text("${cName[0].toUpperCase()}${cName.substring(1)}"),
                        Spacer(),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoryCArd extends StatelessWidget {
  final Category categoria;

  const CategoryCArd(
    this.categoria,
  );

  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context, listen: false);

    return GestureDetector(
      onTap: () {
        final newsService = Provider.of<NewsService>(context, listen: false);
        newsService.selectedCategory = categoria.name;
        print(newsService.selectedCategory);
        Route route = MaterialPageRoute(builder: (_) => Hamburger());
        Navigator.pushReplacement(context, route);
        
      },
      child: Card(
        color: newsService.selectedCategory == this.categoria.name
            ? Colors.black.withOpacity(0.7)
            : Colors.white,
        child: Icon(
          categoria.icon,
          color: newsService.selectedCategory == this.categoria.name
              ? Colors.white
              : Colors.black.withOpacity(0.7),
        ),
        elevation: 3,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}
