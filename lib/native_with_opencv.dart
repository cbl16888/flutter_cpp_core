import 'dart:ffi';// For FFI
import 'dart:io'; // For Platform.isX
import 'package:ffi/ffi.dart';
import 'dart:isolate';

// C function signatures
typedef _hex_to_float_func = Float Function(Pointer<Uint8>);

// Dart function signatures
typedef _HexToFloatFunc = double Function(Pointer<Uint8>);

final DynamicLibrary nativeAddLib =
Platform.isAndroid ? DynamicLibrary.open("libnative_with_opencv.so") : DynamicLibrary.process();

final int Function(int x, int y) nativeAdd =
nativeAddLib.lookup<NativeFunction<Int32 Function(Int32, Int32)>>("native_add").asFunction();

// final double Function(Pointer<Utf8>) hexToFloat =
// nativeAddLib.lookup<NativeFunction<Float Function(Pointer<Utf8>>>("hex_to_float").asFunction();

final _HexToFloatFunc _hexToFloat = nativeAddLib
    .lookup<NativeFunction<_hex_to_float_func>>('hex_to_float')
    .asFunction();

double hexListToFloat(List<int> value) {
    var outBuf = allocate<Uint8>(count: value.length);
    for (int i = 0; i < value.length; i++) {
        outBuf[i] = value[i];
        outBuf[1] = 0xE6;
        outBuf[2] = 0xF6;
        outBuf[3] = 0x42;
    }
    var result = _hexToFloat(outBuf);
    free(outBuf);
    return result;
}




/*
iOS 需要修改一下配置
When creating a release archive (IPA) the symbols are stripped by Xcode.
1. In Xcode, go to **Target Runner > Build Settings > Strip Style**.
2. Change from **All Symbols** to **Non-Global Symbols**.

iOS 需要拷贝一份native_add.cpp到iOS独立项目里面

sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
        main {
            jniLibs.srcDirs = [ 'libs','src/main/nativeLibs']  // libs
        }
    }
    如果报*.so文件重复,注释sourceSets里面的main {
            jniLibs.srcDirs = [ 'libs','src/main/nativeLibs']  // libs
        }
 */