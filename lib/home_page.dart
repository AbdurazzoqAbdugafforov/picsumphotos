import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picsumpphotos/details_page.dart';
import 'package:picsumpphotos/photo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Photo> _photos = [];
  bool _isLoading = false;
  late RefreshController _refreshController;
  int _page = 0;
  bool _isUpwardEneble = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initialFetchPhotos();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= 500) {
        setState(() {
          _isUpwardEneble = true;
        });
      } else {
        setState(() {
          _isUpwardEneble = false;
        });
      }
    });
  }

  Future<void> _initialFetchPhotos() async {
    setState(() {
      _isLoading = true;
    });
    final Uri url = Uri.https(
      'picsum.photos',
      '/v2/list',
      {'page': '${++_page}', 'limit': '15'},
    );
    final response = await http.get(url);
    final List<dynamic> jsonList = json.decode(response.body);
    setState(() {
      _photos = jsonList.map((json) => Photo.fromJson(json)).toList();
      _isLoading = false;
    });
  }

  Future<void> _moreFetchPhotos() async {
    final Uri url = Uri.https(
      'picsum.photos',
      '/v2/list',
      {'page': '${++_page}', 'limit': '15'},
    );
    final response = await http.get(url);
    final List<dynamic> jsonList = json.decode(response.body);
    setState(() {
      _photos.addAll(jsonList.map((json) => Photo.fromJson(json)).toList());
    });
    _refreshController.loadComplete();
  }

  Future<void> _refreshPhotos() async {
    _page = 0;
    final Uri url = Uri.https(
      'picsum.photos',
      '/v2/list',
      {'xpage': '${++_page}', 'limit': '15'},
    );
    final response = await http.get(url);
    final List<dynamic> jsonList = json.decode(response.body);
    setState(() {
      _photos = jsonList.map((json) => Photo.fromJson(json)).toList();
    });
    _refreshController.refreshCompleted();
  }

  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: const CircularProgressIndicator())
          : SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              onLoading: _moreFetchPhotos,
              onRefresh: _refreshPhotos,
              child: ListView.builder(
                  itemCount: _photos.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    DetailsPage(photo: _photos[index])));
                      },
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: '${_photos[index].downloadUrl}',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          Text('${_photos[index].author}'),
                        ],
                      ),
                    );
                  }),
            ),
      floatingActionButton: _isUpwardEneble
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                );
              },
              child: Icon(
                Icons.keyboard_arrow_up,
                size: 40,
              ),
            )
          : null,
    );
  }
}
