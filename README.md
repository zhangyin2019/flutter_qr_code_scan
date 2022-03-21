# flutter_qr_code_scan
### 初衷
在实际APP开发中，扫一扫是必不可少的组件，通过qr_code_scanner来进行封装，以此分享

### 使用方法
* 先把.dart拷贝到自己的公共组件目录中
* pubspec.yaml中安装
```java
qr_code_scanner: ^0.7.0
```

* 使用的地方
```dart
// 扫一扫
void codeScan() async {
  AppUtil.push(
    context,
    QrcodeScanPage(),
  ).then((value) {
    setState(() {
      _xxx = value;
    });

    //
  });

  //
}
```

* 核心代码
```dart
QrcodeScanPage()
```

### 效果
![639f62a90ba415685c88f84b5bf9bcc0](https://user-images.githubusercontent.com/49790909/159233831-a84227b9-3284-42c2-bdd2-274f06c87525.jpg)



