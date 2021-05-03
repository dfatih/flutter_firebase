import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Post {
  String body;
  String author;
  int likes = 0;
  bool userLiked = false;

  Post(this.body, this.author);

  void likePost() {
    this.userLiked = !this.userLiked;
    if (this.userLiked) {
      this.likes += 1;
    } else {
      this.likes -= 1;
    }
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  void newPost(String text) {
    setState(() {
      posts.add(new Post(text, "Max"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello")),
      body: Column(
        children: <Widget>[
          Expanded(child: PostList(this.posts)),
          TextInputWidget(this.newPost),
        ],
      ),
    );
  }
}

class TextInputWidget extends StatefulWidget {
  final Function(String) callback;

  TextInputWidget(this.callback);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void click() {
    FocusScope.of(context).unfocus();
    controller.clear();
    widget.callback(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.message),
          labelText: "Type a message:",
          suffixIcon: IconButton(
              icon: Icon(Icons.send),
              splashColor: Colors.orange,
              onPressed: this.click)),
    );
  }
}

class PostList extends StatefulWidget {
  final List<Post> listItems;

  PostList(this.listItems);
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        var post = this.widget.listItems[index];
        return Card(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: ListTile(
                title: Text(post.body),
                subtitle: Text(post.author),
              )),
              Row(
                children: <Widget>[
                  Container(
                      child: Text(post.likes.toString(),
                          style: TextStyle(fontSize: 20)),
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                  IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () => this.like(post.likePost),
                      color: post.userLiked ? Colors.orange : Colors.black)
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
