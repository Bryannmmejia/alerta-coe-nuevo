import 'package:alertacoe/helper/globalState.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../../assets/network_image.dart';

List<String> images = [
  "${GlobalState.getInstance().baseUrlImage}bg_cover_recomendation.jpeg"
];

class RecommendationViewPage extends StatefulWidget {
  final dynamic data;

  RecommendationViewPage(this.data, {Key? key}) : super(key: key);

  @override
  _RecommendationViewPageState createState() => _RecommendationViewPageState();
}

class _RecommendationViewPageState extends State<RecommendationViewPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  int prevIndex = 0;
  late final SwiperController _swiperController;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _swiperController = SwiperController();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Swiper(
              physics: BouncingScrollPhysics(),
              viewportFraction: 0.8,
              itemCount: widget.data.length,
              loop: true,
              controller: _swiperController,
              onIndexChanged: (index) {
                _controller.reverse();
                setState(() {
                  prevIndex = currentIndex;
                  currentIndex = index;
                  _controller.forward();
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, bottom: 16, top: 10),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () => null,
                              child: Hero(
                                tag: "image$index",
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: PNetworkImage(
                                    images[0],
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height, width: 200,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: MediaQuery.of(context).size.width / 4,
                              right: MediaQuery.of(context).size.width / 4,
                              child: Row(
                                children: [_headerText(index)],
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              pagination: SwiperPagination(
                margin: const EdgeInsets.all(5.0),
                builder: DotSwiperPaginationBuilder(
                  size: 5,
                  activeSize: 5,
                  color: Colors.black26,
                  activeColor: Colors.blue[900],
                ),
              ),
            ),
          ),
          _buildDesc(currentIndex),
        ],
      ),
    );
  }

  Widget _headerText(int index) {
    String text = index == 0
        ? "ANTES"
        : index == 1
            ? "DURANTE"
            : "DESPUES";
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildDesc(int index) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 10),
      width: double.infinity,
      height: 400,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(height: 1.0),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.data[index]["text"] ?? "",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
