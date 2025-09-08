import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Cesium-powered 3D Globe Widget
/// Uses WebView to embed Cesium.js for true 3D rendering
class CesiumGlobe3D extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback? onResetView;
  final Function(double lat, double lng)? onLocationChanged;
  final Map<String, dynamic>? dataLayers;
  
  const CesiumGlobe3D({
    super.key,
    this.width = 400,
    this.height = 400,
    this.onResetView,
    this.onLocationChanged,
    this.dataLayers,
  });

  @override
  State<CesiumGlobe3D> createState() => _CesiumGlobe3DState();
}

class _CesiumGlobe3DState extends State<CesiumGlobe3D> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  @override
  void dispose() {
    // Clean up Cesium viewer to prevent memory leaks
    _controller.runJavaScript('''
      if (window.cesiumViewer) {
        window.cesiumViewer.destroy();
        window.cesiumViewer = null;
      }
    ''');
    super.dispose();
  }

  void _initializeWebView() {
    _controller = WebViewController();
    
    // Only set JavaScript mode for non-web platforms
    if (!kIsWeb) {
      _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    }
    
    _controller
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          _handleJavaScriptMessage(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Initialize Cesium after page loads
            Future.delayed(const Duration(milliseconds: 2000), () {
              _initializeCesium();
            });
          },
        ),
      )
      ..loadHtmlString(_getCesiumHTML());
  }

  void _handleJavaScriptMessage(String message) {
    try {
      final data = jsonDecode(message);
      switch (data['type']) {
        case 'locationChanged':
          widget.onLocationChanged?.call(
            data['lat'] as double,
            data['lng'] as double,
          );
          break;
        case 'globeReady':
          _onGlobeReady();
          break;
        case 'error':
          setState(() {
            _hasError = true;
            _errorMessage = data['message'] as String;
          });
          break;
      }
    } catch (e) {
      print('Error parsing JavaScript message: $e');
    }
  }

  void _onGlobeReady() {
    setState(() {
      _isLoading = false;
    });
    
    // Load data layers if provided
    if (widget.dataLayers != null) {
      _loadDataLayers();
    }
  }

  void _loadDataLayers() {
    final layersJson = jsonEncode(widget.dataLayers);
    _controller.runJavaScript('''
      if (window.cesiumViewer) {
        window.loadDataLayers($layersJson);
      }
    ''');
  }

  void _initializeCesium() {
    // Cesium initialization is now handled in the HTML itself
    // This method is kept for compatibility but does nothing
  }

  String _getCesiumHTML() {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
    <title>Cesium Globe</title>
    <script src="https://cesium.com/downloads/cesiumjs/releases/1.111/Build/Cesium/Cesium.js"></script>
    <link href="https://cesium.com/downloads/cesiumjs/releases/1.111/Build/Cesium/Widgets/widgets.css" rel="stylesheet">
    <style>
        html, body, #cesiumContainer {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden;
            font-family: sans-serif;
        }
        
        .loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 18px;
            z-index: 1000;
        }
        
        .error {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #ff6b6b;
            font-size: 16px;
            text-align: center;
            z-index: 1000;
            background: rgba(0, 0, 0, 0.8);
            padding: 20px;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div id="cesiumContainer"></div>
    <div id="loading" class="loading">Loading Cesium Globe...</div>
    
    <script>
        // Set Cesium Ion access token
        Cesium.Ion.defaultAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1NTA0MmZhZi0zNzc3LTRiNzItOGJiNS1hYzcxNzAyOTI0YTgiLCJpZCI6MzM4ODYwLCJpYXQiOjE3NTcxMTY5OTF9.CnDKHaxBmkJEXhz1lhhpui6rNmUZzF7ruXNfsPQIqtI';
        
        // Initialize Cesium when page loads
        window.addEventListener('load', function() {
            console.log('Page loaded, starting Cesium initialization...');
            setTimeout(function() {
                try {
                    initializeCesium();
                } catch (error) {
                    console.error('Cesium initialization error:', error);
                    showError(error.toString());
                }
            }, 1500);
        });
        
        function showError(message) {
            const loadingElement = document.getElementById('loading');
            if (loadingElement) {
                loadingElement.innerHTML = 
                    '<div style="color: #ff6b6b; text-align: center;">' +
                        '<h3>Error Loading 3D Globe</h3>' +
                        '<p>' + message + '</p>' +
                        '<button onclick="location.reload()" style="background: #2196F3; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;">Retry</button>' +
                    '</div>';
            }
        }
        
        // Cesium initialization function
        function initializeCesium() {
            try {
                // Check if Cesium is available
                if (typeof Cesium === 'undefined') {
                    throw new Error('Cesium library not loaded');
                }
                
                // Initialize Cesium viewer with optimized settings for memory
                window.cesiumViewer = new Cesium.Viewer('cesiumContainer', {
                    terrainProvider: Cesium.createWorldTerrain({
                        requestWaterMask: false,
                        requestVertexNormals: false
                    }),
                    timeline: false,
                    animation: false,
                    baseLayerPicker: false,
                    fullscreenButton: false,
                    vrButton: false,
                    geocoder: false,
                    homeButton: false,
                    infoBox: false,
                    sceneModePicker: false,
                    selectionIndicator: false,
                    navigationHelpButton: false,
                    navigationInstructionsInitiallyVisible: false,
                    scene3DOnly: true,
                    shouldAnimate: true,
                    // Memory optimization settings
                    contextOptions: {
                        requestWebgl2: false,
                        alpha: false,
                        depth: true,
                        stencil: false,
                        antialias: false,
                        premultipliedAlpha: true,
                        preserveDrawingBuffer: false,
                        failIfMajorPerformanceCaveat: false
                    }
                });

                // Configure camera
                window.cesiumViewer.camera.setView({
                    destination: Cesium.Cartesian3.fromDegrees(0.0, 0.0, 20000000.0),
                    orientation: {
                        heading: 0.0,
                        pitch: Cesium.Math.toRadians(-90.0),
                        roll: 0.0
                    }
                });

                // Add high-quality Earth imagery from Ion
                window.cesiumViewer.imageryLayers.removeAll();
                window.cesiumViewer.imageryLayers.addImageryProvider(
                    Cesium.IonImageryProvider.fromAssetId(1)
                );

                // Add atmosphere
                window.cesiumViewer.scene.skyAtmosphere.show = true;
                window.cesiumViewer.scene.globe.enableLighting = true;
                window.cesiumViewer.scene.globe.dynamicAtmosphereLighting = true;
                window.cesiumViewer.scene.globe.atmosphereLightIntensity = 10.0;

                // Add click handler for location changes
                window.cesiumViewer.cesiumWidget.screenSpaceEventHandler.setInputAction(
                    function onLeftClick(event) {
                        const pickedPosition = window.cesiumViewer.camera.pickEllipsoid(
                            event.position,
                            window.cesiumViewer.scene.globe.ellipsoid
                        );
                        
                        if (pickedPosition) {
                            const cartographic = Cesium.Cartographic.fromCartesian(pickedPosition);
                            const longitude = Cesium.Math.toDegrees(cartographic.longitude);
                            const latitude = Cesium.Math.toDegrees(cartographic.latitude);
                            
                            if (window.FlutterChannel) {
                                FlutterChannel.postMessage(JSON.stringify({
                                    type: 'locationChanged',
                                    lat: latitude,
                                    lng: longitude
                                }));
                            }
                        }
                    },
                    Cesium.ScreenSpaceEventType.LEFT_CLICK
                );

                // Hide loading indicator
                const loadingElement = document.getElementById('loading');
                if (loadingElement) {
                    loadingElement.style.display = 'none';
                }
                
                // Notify Flutter that globe is ready
                if (window.FlutterChannel) {
                    FlutterChannel.postMessage(JSON.stringify({
                        type: 'globeReady'
                    }));
                }
                
                console.log('Cesium globe initialized successfully!');

                // Auto-rotate the globe
                window.cesiumViewer.clock.onTick.addEventListener(function() {
                    window.cesiumViewer.scene.camera.rotate(
                        Cesium.Cartesian3.UNIT_Z,
                        Cesium.Math.toRadians(0.1)
                    );
                });

            } catch (error) {
                console.error('Cesium initialization error:', error);
                if (window.FlutterChannel) {
                    FlutterChannel.postMessage(JSON.stringify({
                        type: 'error',
                        message: error.toString()
                    }));
                }
            }
        }
        
        // Function to load data layers
        window.loadDataLayers = function(layers) {
            if (!window.cesiumViewer) return;
            
            try {
                // Clear existing data sources
                window.cesiumViewer.dataSources.removeAll();
                
                // Add MODIS data if enabled
                if (layers.modis && layers.modis.enabled) {
                    const modisDataSource = new Cesium.CustomDataSource('MODIS');
                    // Add MODIS imagery or data points here
                    window.cesiumViewer.dataSources.add(modisDataSource);
                }
                
                // Add other data layers as needed
                // MOPITT, CERES, ASTER, MISR, etc.
                
            } catch (error) {
                console.error('Error loading data layers:', error);
            }
        };
        
        // Error handling
        window.addEventListener('error', function(e) {
            console.error('JavaScript error:', e);
            if (window.FlutterChannel) {
                FlutterChannel.postMessage(JSON.stringify({
                    type: 'error',
                    message: e.message || 'Unknown JavaScript error'
                }));
            }
        });
        
        // Handle unhandled promise rejections
        window.addEventListener('unhandledrejection', function(e) {
            console.error('Unhandled promise rejection:', e);
            if (window.FlutterChannel) {
                FlutterChannel.postMessage(JSON.stringify({
                    type: 'error',
                    message: 'Promise rejection: ' + (e.reason || 'Unknown error')
                }));
            }
        });
    </script>
</body>
</html>
    ''';
  }

  void resetView() {
    _controller.runJavaScript('''
      if (window.cesiumViewer) {
        window.cesiumViewer.camera.setView({
          destination: Cesium.Cartesian3.fromDegrees(0.0, 0.0, 20000000.0),
          orientation: {
            heading: 0.0,
            pitch: Cesium.Math.toRadians(-90.0),
            roll: 0.0
          }
        });
      }
    ''');
    widget.onResetView?.call();
  }

  void zoomIn() {
    _controller.runJavaScript('''
      if (window.cesiumViewer) {
        const camera = window.cesiumViewer.camera;
        camera.zoomIn(camera.positionCartographic.height * 0.5);
      }
    ''');
  }

  void zoomOut() {
    _controller.runJavaScript('''
      if (window.cesiumViewer) {
        const camera = window.cesiumViewer.camera;
        camera.zoomOut(camera.positionCartographic.height * 0.5);
      }
    ''');
  }

  void toggleRotation() {
    _controller.runJavaScript('''
      if (window.cesiumViewer) {
        window.cesiumViewer.clock.shouldAnimate = !window.cesiumViewer.clock.shouldAnimate;
      }
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (_hasError)
              Container(
                color: const Color(0xFF0A0A0A),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load 3D Globe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage ?? 'Unknown error occurred',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _hasError = false;
                            _isLoading = true;
                          });
                          _initializeWebView();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else
              _buildWebView(),
            
            if (_isLoading && !_hasError)
              Container(
                color: const Color(0xFF0A0A0A),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF2196F3),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading 3D Globe...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView() {
    // Use WebView for all platforms - it works better than iframe approach
    return WebViewWidget(controller: _controller);
  }
}

/// Extension for adding NASA Terra instrument data overlays
extension CesiumGlobeOverlays on CesiumGlobe3D {
  /// Add MODIS data overlay
  static Widget withModisOverlay(CesiumGlobe3D globe, dynamic modisData) {
    return globe;
  }
  
  /// Add MOPITT data overlay
  static Widget withMopittOverlay(CesiumGlobe3D globe, dynamic mopittData) {
    return globe;
  }
  
  /// Add CERES data overlay
  static Widget withCeresOverlay(CesiumGlobe3D globe, dynamic ceresData) {
    return globe;
  }
}
