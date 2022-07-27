import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(28.6151421, 77.0329023);
  static const LatLng destination = LatLng(28.6149173,77.0329372);

  List<LatLng> polylineCoordinates = [LatLng(28.6151421,77.0329023),
    LatLng(28.615215,77.03323),
    LatLng(28.6151763,77.0332265),
    LatLng(28.6151575,77.0331434),
    LatLng(28.6151435,77.0331662),
    LatLng(28.6151179,77.0331798),
    LatLng(28.6150938,77.0331904),
    LatLng(28.6150707,77.0331918),
    LatLng(28.6150467,77.0331888),
    LatLng(28.6150219,77.033191),
    LatLng(28.6149783,77.033215),
    LatLng(28.6149322,77.0332218),
    LatLng(28.6148961,77.0332288),
    LatLng(28.6148628,77.0332423),
    LatLng(28.6148362,77.0332613),
    LatLng(28.614808,77.033279),
    LatLng(28.6147776,77.0332947),
    LatLng(28.614758,77.0332997),
    LatLng(28.6147539,77.0332996),
    LatLng(28.6147503,77.0333004),
    LatLng(28.6146979,77.0332863),
    LatLng(28.6146573,77.033251),
    LatLng(28.6145997,77.0331965),
    LatLng(28.6145593,77.0331795),
    LatLng(28.614517,77.0331709),
    LatLng(28.6144746,77.033167),
    LatLng(28.6144298,77.0331704),
    LatLng(28.6143943,77.0331774),
    LatLng(28.6143468,77.0331908),
    LatLng(28.6143052,77.033206),
    LatLng(28.6142464,77.033228),
    LatLng(28.6141914,77.0332469),
    LatLng(28.6141211,77.0332687),
    LatLng(28.6140719,77.0332829),
    LatLng(28.6139893,77.0333014),
    LatLng(28.6139228,77.0333147),
    LatLng(28.6138627,77.0333278),
    LatLng(28.613802,77.0333472),
    LatLng(28.6137421,77.033373),
    LatLng(28.6136862,77.0334016),
    LatLng(28.6136291,77.0334281),
    LatLng(28.6135739,77.0334509),
    LatLng(28.6135139,77.0334691),
    LatLng(28.6134527,77.0334853),
    LatLng(28.6133925,77.0335003),
    LatLng(28.6133336,77.0335147),
    LatLng(28.6132841,77.0335257),
    LatLng(28.6132408,77.0335306),
    LatLng(28.6132044,77.0335275),
    LatLng(28.6131781,77.0335127),
    LatLng(28.61316,77.0334953),
    LatLng(28.613149,77.0334818),
    LatLng(28.6131411,77.0334713),
    LatLng(28.6131358,77.0334645),
    LatLng(28.6131333,77.0334597),
    LatLng(28.6131284,77.0334555),
    LatLng(28.6131277,77.0334559),
    LatLng(28.613112,77.0334592),
    LatLng(28.6130933,77.0334658),
    LatLng(28.6130775,77.0334695),
    LatLng(28.6130607,77.0334737),
    LatLng(28.6130461,77.0334773),
    LatLng(28.6130162,77.0334861),
    LatLng(28.6129785,77.0334966),
    LatLng(28.612905,77.0335225),
    LatLng(28.6127943,77.0335576),
    LatLng(28.6127264,77.0335784),
    LatLng(28.6126665,77.0335962),
    LatLng(28.6125882,77.0336195),
    LatLng(28.6125099,77.03364),
    LatLng(28.6124295,77.0336624),
    LatLng(28.6123457,77.0336882),
    LatLng(28.6122563,77.0337116),
    LatLng(28.6121663,77.0337383),
    LatLng(28.6120754,77.0337666),
    LatLng(28.61198,77.0337949),
    LatLng(28.6118824,77.0338251),
    LatLng(28.6117857,77.0338543),
    LatLng(28.6116871,77.0338843),
    LatLng(28.6115888,77.0339155),
    LatLng(28.6114898,77.0339484),
    LatLng(28.6113901,77.0339818),
    LatLng(28.6112893,77.0340147),
    LatLng(28.6111867,77.0340481),
    LatLng(28.6110829,77.0340834),
    LatLng(28.6109786,77.034119),
    LatLng(28.6108741,77.0341518),
    LatLng(28.6107667,77.0341838),
    LatLng(28.6106582,77.0342157),
    LatLng(28.6105458,77.0342488),
    LatLng(28.6104372,77.0342785),
    LatLng(28.6103272,77.0343104),
    LatLng(28.6102161,77.0343438),
    LatLng(28.6101055,77.0343778),
    LatLng(28.609999,77.0344105),
    LatLng(28.6098888,77.0344458),
    LatLng(28.609786,77.0344791),
    LatLng(28.6096836,77.0345118),
    LatLng(28.6095797,77.0345406),
    LatLng(28.6094715,77.0345697),
    LatLng(28.6093708,77.0345983),
    LatLng(28.6092702,77.0346267),
    LatLng(28.6091666,77.0346581),
    LatLng(28.6090635,77.0346901),
    LatLng(28.6089593,77.0347232),
    LatLng(28.6088561,77.034755),
    LatLng(28.6087533,77.034787),
    LatLng(28.6086561,77.0348175),
    LatLng(28.6085665,77.0348448),
    LatLng(28.6084823,77.034871),
    LatLng(28.6084014,77.0348981),
    LatLng(28.6083197,77.0349249),
    LatLng(28.608239,77.0349519),
    LatLng(28.6081531,77.0349774),
    LatLng(28.6080675,77.0350055),
    LatLng(28.607978,77.0350352),
    LatLng(28.6078854,77.0350691),
    LatLng(28.6077911,77.0351016),
    LatLng(28.6076923,77.0351334),
    LatLng(28.6075971,77.0351642),
    LatLng(28.6074994,77.0351951),
    LatLng(28.6074042,77.0352258),
    LatLng(28.6073103,77.0352583),
    LatLng(28.6072164,77.0352908),
    LatLng(28.6071259,77.0353221),
    LatLng(28.6070365,77.0353533),
    LatLng(28.6069498,77.03538),
    LatLng(28.6068713,77.0354035),
    LatLng(28.6068054,77.0354257),
    LatLng(28.6067507,77.0354459),
    LatLng(28.6067066,77.0354639),
    LatLng(28.6066878,77.0354725),
    LatLng(28.6066566,77.035488),
    LatLng(28.6066357,77.0354973),
    LatLng(28.6066239,77.0355008),
    LatLng(28.6066187,77.0355014),
    LatLng(28.606615,77.0354982),
    LatLng(28.6066136,77.035497),
    LatLng(28.6066134,77.0354968),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6066133,77.0354967),
    LatLng(28.6065762,77.035506),
    LatLng(28.6065179,77.0355222),
    LatLng(28.6064765,77.0355357),
    LatLng(28.6064416,77.0355495),
    LatLng(28.6063874,77.0355696),
    LatLng(28.6063349,77.0355826),
    LatLng(28.6062816,77.0355842),
    LatLng(28.6062294,77.0355702),
    LatLng(28.6061833,77.035543),
    LatLng(28.6061405,77.0355081),
    LatLng(28.6060986,77.0354707),
    LatLng(28.6060539,77.0354246),
    LatLng(28.6060041,77.0353798),
    LatLng(28.6059468,77.0353402),
    LatLng(28.6058925,77.0352989),
    LatLng(28.6058378,77.0352539),
    LatLng(28.6057806,77.0352071),
    LatLng(28.6057232,77.0351555),
    LatLng(28.6056635,77.0350991),
    LatLng(28.605602,77.0350404),
    LatLng(28.6055378,77.0349812),
    LatLng(28.6054704,77.0349184),
    LatLng(28.6054011,77.0348563),
    LatLng(28.6053262,77.0347928),
    LatLng(28.6052494,77.0347263),
    LatLng(28.6051699,77.0346589),
    LatLng(28.6050899,77.0345912),
    LatLng(28.6050113,77.0345232),
    LatLng(28.6049326,77.0344563),
    LatLng(28.6048498,77.0343889),
    LatLng(28.6047643,77.0343209),
    LatLng(28.604674,77.0342509),
    LatLng(28.6045845,77.0341818),
    LatLng(28.6044971,77.0341116),
    LatLng(28.6044113,77.0340442),
    LatLng(28.6043329,77.0339815),
    LatLng(28.6042616,77.0339246),
    LatLng(28.6041967,77.0338746),
    LatLng(28.6041399,77.0338345),
    LatLng(28.6040932,77.0338017),
    LatLng(28.604053,77.0337779),
    LatLng(28.6040322,77.033767),
    LatLng(28.6040056,77.0337522),
    LatLng(28.6039825,77.0337379),
    LatLng(28.6039718,77.0337261),
    LatLng(28.6039667,77.0337187),
    LatLng(28.6039661,77.0337159),
    LatLng(28.6039676,77.0337153),
    LatLng(28.6039681,77.0337151),
    LatLng(28.6039682,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039683,77.033715),
    LatLng(28.6039455,77.0336797),
    LatLng(28.6039283,77.0336599),
    LatLng(28.6039035,77.0336419),
    LatLng(28.6038815,77.0336255),
    LatLng(28.6038534,77.0336016),
    LatLng(28.6038287,77.0335813),
    LatLng(28.6038002,77.0335568),
    LatLng(28.6037573,77.0335182),
    LatLng(28.6037102,77.0334788),
    LatLng(28.6036665,77.0334386),
    LatLng(28.6036232,77.0333961),
    LatLng(28.6035762,77.0333496),
    LatLng(28.6035201,77.033301),
    LatLng(28.6034594,77.033249),
    LatLng(28.6033917,77.0331941),
    LatLng(28.6033232,77.0331354),
    LatLng(28.6032525,77.0330707),
    LatLng(28.6031809,77.0330062),
    LatLng(28.6031108,77.0329395),
    LatLng(28.6030463,77.032871),
    LatLng(28.602979,77.0328),
    LatLng(28.6029065,77.0327293),
    LatLng(28.602829,77.0326598),
    LatLng(28.6027498,77.0325907),
    LatLng(28.6026656,77.032521),
    LatLng(28.602581,77.0324509),
    LatLng(28.6024955,77.0323791),
    LatLng(28.6024111,77.0323048),
    LatLng(28.6023238,77.0322291),
    LatLng(28.6022345,77.0321513),
    LatLng(28.6021431,77.0320696),
    LatLng(28.6020497,77.0319864),
    LatLng(28.6019533,77.0319023),
    LatLng(28.6018591,77.0318232),
    LatLng(28.6017611,77.0317412),
    LatLng(28.6016601,77.031655),
    LatLng(28.6015629,77.03157),
    LatLng(28.6014629,77.0314843),
    LatLng(28.6013613,77.0313998),
    LatLng(28.60126,77.0313185),
    LatLng(28.6011592,77.0312368),
    LatLng(28.6010561,77.0311557),
    LatLng(28.6009561,77.0310747),
    LatLng(28.6008545,77.0309899),
    LatLng(28.6007549,77.0309069),
    LatLng(28.6006523,77.0308221),
    LatLng(28.600551,77.0307378),
    LatLng(28.6004494,77.030651),
    LatLng(28.6003489,77.030565),
    LatLng(28.6002509,77.0304787),
    LatLng(28.6001615,77.0303996),
    LatLng(28.6000795,77.0303292),
    LatLng(28.6000072,77.0302682),
    LatLng(28.5999449,77.030222),
    LatLng(28.5998896,77.0301851),
    LatLng(28.5998353,77.0301607),
    LatLng(28.5997788,77.0301473),
    LatLng(28.5997217,77.0301443),
    LatLng(28.5996662,77.0301466),
    LatLng(28.5996076,77.0301531),
    LatLng(28.5995478,77.0301578),
    LatLng(28.5994854,77.0301512),
    LatLng(28.5994238,77.0301304),
    LatLng(28.5993628,77.030095),
    LatLng(28.5993025,77.0300493),
    LatLng(28.599264,77.0299856),
    LatLng(28.5992446,77.0299139),
    LatLng(28.5992374,77.0298411),
    LatLng(28.5992437,77.0297719),
    LatLng(28.5992598,77.0297053),
    LatLng(28.599287,77.0296414),
    LatLng(28.5993246,77.0295816),
    LatLng(28.5993686,77.0295355),
    LatLng(28.5994121,77.0295034),
    LatLng(28.5994591,77.0294808),
    LatLng(28.5995161,77.0294655),
    LatLng(28.599576,77.0294619),
    LatLng(28.5996378,77.0294713),
    LatLng(28.5996982,77.0294952),
    LatLng(28.5997572,77.0295337),
    LatLng(28.5998078,77.0295844),
    LatLng(28.5998427,77.0296434),
    LatLng(28.5998652,77.0297005),
    LatLng(28.5998821,77.0297553),
    LatLng(28.5999,77.0298081),
    LatLng(28.5999185,77.0298561),
    LatLng(28.5999281,77.0298783),
    LatLng(28.5999429,77.0299198),
    LatLng(28.5999514,77.0299519),
    LatLng(28.5999649,77.0300002),
    LatLng(28.5999825,77.0300484),
    LatLng(28.6000138,77.030097),
    LatLng(28.600055,77.0301439),
    LatLng(28.6001046,77.0301913),
    LatLng(28.6001556,77.0302382),
    LatLng(28.6002104,77.0302876),
    LatLng(28.600267,77.0303403),
    LatLng(28.6003303,77.0303953),
    LatLng(28.600394,77.0304563),
    LatLng(28.6004659,77.0305208),
    LatLng(28.6005379,77.0305847),
    LatLng(28.600611,77.0306458),
    LatLng(28.6006874,77.0307124),
    LatLng(28.6007649,77.0307781),
    LatLng(28.6008428,77.0308481),
    LatLng(28.6009242,77.0309233),
    LatLng(28.6010043,77.0309969),
    LatLng(28.6010818,77.0310668),
    LatLng(28.6011561,77.0311339),
    LatLng(28.6012315,77.0312015),
    LatLng(28.6013084,77.0312693),
    LatLng(28.6013846,77.0313366),
    LatLng(28.6014637,77.0314048),
    LatLng(28.6015472,77.0314721),
    LatLng(28.6016316,77.0315417),
    LatLng(28.601716,77.0316082),
    LatLng(28.601803,77.0316777),
    LatLng(28.6018852,77.0317464),
    LatLng(28.6019687,77.0318176),
    LatLng(28.6020545,77.0318927),
    LatLng(28.6021451,77.0319703),
    LatLng(28.6022381,77.0320459),
    LatLng(28.6023329,77.0321246),
    LatLng(28.6024273,77.0322029),
    LatLng(28.6025235,77.0322812),
    LatLng(28.6026164,77.0323604),
    LatLng(28.6027105,77.0324398),
    LatLng(28.6028019,77.0325184),
    LatLng(28.6028933,77.0325927),
    LatLng(28.6029821,77.0326663),
    LatLng(28.6030694,77.0327383),
    LatLng(28.6031572,77.0328114),
    LatLng(28.6032453,77.0328852),
    LatLng(28.6033282,77.0329565),
    LatLng(28.6034095,77.0330238),
    LatLng(28.6034835,77.0330851),
    LatLng(28.6035483,77.0331389),
    LatLng(28.6036055,77.0331829),
    LatLng(28.6036529,77.0332168),
    LatLng(28.6036954,77.0332467),
    LatLng(28.6037226,77.0332671),
    LatLng(28.6037446,77.0332874),
    LatLng(28.6037536,77.0332974),
    LatLng(28.6037599,77.0333082),
    LatLng(28.6037601,77.0333129),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.60376,77.0333167),
    LatLng(28.6037774,77.033338),
    LatLng(28.6038174,77.0333825),
    LatLng(28.6038412,77.0334065),
    LatLng(28.6038712,77.0334329),
    LatLng(28.603911,77.0334661),
    LatLng(28.6039567,77.0334994),
    LatLng(28.6040009,77.0335341),
    LatLng(28.6040409,77.0335706),
    LatLng(28.6040783,77.0336069),
    LatLng(28.6041194,77.0336415),
    LatLng(28.6041657,77.0336798),
    LatLng(28.6042156,77.0337218),
    LatLng(28.604268,77.0337688),
    LatLng(28.6043207,77.033823),
    LatLng(28.6043805,77.0338816),
    LatLng(28.6044456,77.0339427),
    LatLng(28.6045173,77.0340065),
    LatLng(28.6045941,77.0340736),
    LatLng(28.6046727,77.0341393),
    LatLng(28.6047521,77.0342065),
    LatLng(28.6048353,77.0342765),
    LatLng(28.6049217,77.0343492),
    LatLng(28.6050096,77.0344226),
    LatLng(28.6051007,77.0344969),
    LatLng(28.6051918,77.0345738),
    LatLng(28.6052804,77.0346505),
    LatLng(28.6053693,77.0347273),
    LatLng(28.6054591,77.0348022),
    LatLng(28.6055467,77.0348749),
    LatLng(28.6056314,77.0349471),
    LatLng(28.6057115,77.0350165),
    LatLng(28.6057833,77.0350774),
    LatLng(28.6058493,77.0351305),
    LatLng(28.605912,77.0351803),
    LatLng(28.6059689,77.0352247),
    LatLng(28.6060165,77.0352605),
    LatLng(28.6060526,77.0352885),
    LatLng(28.6060781,77.0353079),
    LatLng(28.6061008,77.035321),
    LatLng(28.6061139,77.0353269),
    LatLng(28.606124,77.0353343),
    LatLng(28.6061286,77.0353362),
    LatLng(28.6061285,77.0353343),
    LatLng(28.6061309,77.0353335),
    LatLng(28.6061314,77.0353333),
    LatLng(28.6061316,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061317,77.0353333),
    LatLng(28.6061623,77.0353796),
    LatLng(28.6061967,77.0354253),
    LatLng(28.6062144,77.0354457),
    LatLng(28.6062397,77.0354783),
    LatLng(28.6062479,77.0354986),
    LatLng(28.6062624,77.0355401),
    LatLng(28.6062682,77.0355758),
    LatLng(28.6062681,77.0356387),
    LatLng(28.6062574,77.0356976),
    LatLng(28.6062368,77.035749),
    LatLng(28.60621,77.0357931),
    LatLng(28.6061849,77.0358237),
    LatLng(28.6061607,77.0358535),
    LatLng(28.6061284,77.0358952),
    LatLng(28.6060949,77.0359406),
    LatLng(28.6060601,77.0359875),
    LatLng(28.6060262,77.0360406),
    LatLng(28.6059889,77.0360968),
    LatLng(28.6059484,77.0361565),
    LatLng(28.6059029,77.0362197),
    LatLng(28.6058554,77.0362859),
    LatLng(28.6058082,77.0363518),
    LatLng(28.6057573,77.0364196),
    LatLng(28.6057044,77.0364914),
    LatLng(28.6056516,77.0365645),
    LatLng(28.6055978,77.0366426),
    LatLng(28.6055445,77.0367198),
    LatLng(28.60549,77.0368009),
    LatLng(28.6054354,77.0368838),
    LatLng(28.6053804,77.0369676),
    LatLng(28.6053238,77.0370519),
    LatLng(28.6052639,77.0371402),
    LatLng(28.6052059,77.0372249),
    LatLng(28.6051458,77.03731),
    LatLng(28.6050854,77.0373947),
    LatLng(28.6050208,77.0374856),
    LatLng(28.6049555,77.0375776),
    LatLng(28.6048902,77.0376753),
    LatLng(28.6048241,77.0377765),
    LatLng(28.6047545,77.0378797),
    LatLng(28.6046892,77.0379773),
    LatLng(28.6046262,77.0380791),
    LatLng(28.6045644,77.0381783),
    LatLng(28.6045031,77.0382764),
    LatLng(28.6044438,77.0383735),
    LatLng(28.604384,77.0384707),
    LatLng(28.6043218,77.0385708),
    LatLng(28.6042573,77.0386741),
    LatLng(28.6041984,77.0387744),
    LatLng(28.604137,77.0388766),
    LatLng(28.604077,77.0389711),
    LatLng(28.6040225,77.0390586),
    LatLng(28.6039721,77.0391384),
    LatLng(28.6039285,77.0392115),
    LatLng(28.6038932,77.0392756),
    LatLng(28.6038611,77.0393328),
    LatLng(28.6038353,77.03938),
    LatLng(28.6038221,77.0394016),
    LatLng(28.6038058,77.0394283),
    LatLng(28.6037971,77.0394428),
    LatLng(28.6037966,77.0394435),
    LatLng(28.6037958,77.0394438),
    LatLng(28.6037955,77.0394437),
    LatLng(28.6037951,77.0394434),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.603795,77.0394433),
    LatLng(28.6037716,77.0394819),
    LatLng(28.603749,77.039521),
    LatLng(28.6037463,77.0395282),
    LatLng(28.6037431,77.0395332),
    LatLng(28.6037406,77.039536),
    LatLng(28.6037401,77.0395366),
    LatLng(28.60374,77.0395367),
    LatLng(28.60374,77.0395367),
    LatLng(28.60374,77.0395367),
    LatLng(28.60374,77.0395367),
    LatLng(28.6037447,77.0395627),
    LatLng(28.6037588,77.039596),
    LatLng(28.6037798,77.039608),
    LatLng(28.6038078,77.0396143),
    LatLng(28.6038341,77.0396066),
    LatLng(28.6038513,77.0395891),
    LatLng(28.6038666,77.0395684),
    LatLng(28.6038937,77.0395315),
    LatLng(28.603933,77.0394728),
    LatLng(28.6039731,77.0394166),
    LatLng(28.6040144,77.0393611),
    LatLng(28.6040582,77.039306),
    LatLng(28.6041024,77.0392447),
    LatLng(28.6041481,77.0391794),
    LatLng(28.6041972,77.0391113),
    LatLng(28.6042466,77.0390429),
    LatLng(28.6042934,77.0389762),
    LatLng(28.6043391,77.0389134),
    LatLng(28.6043788,77.0388522),
    LatLng(28.6044164,77.0387917),
    LatLng(28.6044567,77.0387303),
    LatLng(28.6044978,77.0386773),
    LatLng(28.6045213,77.038636),
    LatLng(28.6045479,77.0385924),
    LatLng(28.60457,77.0385441),
    LatLng(28.6045807,77.0384937),
    LatLng(28.6045948,77.0384714),
    LatLng(28.604608,77.0384599),
    LatLng(28.6046263,77.038439),
    LatLng(28.6046434,77.0384139),
    LatLng(28.6046632,77.0383848),
    LatLng(28.6046881,77.038347),
    LatLng(28.604705,77.0383198),
    LatLng(28.6047338,77.038272),
    LatLng(28.6047547,77.038237),
    LatLng(28.6047793,77.0381954),
    LatLng(28.6048122,77.0381513),
    LatLng(28.6048502,77.0381004),
    LatLng(28.6048858,77.038051),
    LatLng(28.6049207,77.0380011),
    LatLng(28.6049573,77.0379502),
    LatLng(28.6049896,77.0378917),
    LatLng(28.605027,77.0378285),
    LatLng(28.6050734,77.037765),
    LatLng(28.6051249,77.0376991),
    LatLng(28.6051749,77.0376261),
    LatLng(28.6052202,77.0375495),
    LatLng(28.6052661,77.0374737),
    LatLng(28.6053117,77.037402),
    LatLng(28.6053619,77.0373328),
    LatLng(28.6054131,77.0372639),
    LatLng(28.6054585,77.0371941),
    LatLng(28.6055028,77.0371236),
    LatLng(28.6055502,77.0370518),
    LatLng(28.6055999,77.0369805),
    LatLng(28.6056514,77.0369096),
    LatLng(28.6057018,77.0368353),
    LatLng(28.6057495,77.0367595),
    LatLng(28.6057992,77.0366849),
    LatLng(28.6058458,77.0366125),
    LatLng(28.6058927,77.036543),
    LatLng(28.605941,77.0364731),
    LatLng(28.6059866,77.0364055),
    LatLng(28.606032,77.0363387),
    LatLng(28.6060705,77.0362754),
    LatLng(28.6061093,77.0362167),
    LatLng(28.606148,77.0361609),
    LatLng(28.6061866,77.036109),
    LatLng(28.6062216,77.0360625),
    LatLng(28.6062512,77.0360241),
    LatLng(28.6062685,77.0359979),
    LatLng(28.606287,77.0359657),
    LatLng(28.6063018,77.0359398),
    LatLng(28.6063119,77.0359206),
    LatLng(28.6063214,77.0359053),
    LatLng(28.606328,77.0358945),
    LatLng(28.6063342,77.0358791),
    LatLng(28.6063419,77.0358659),
    LatLng(28.6063542,77.0358486),
    LatLng(28.6063702,77.0358296),
    LatLng(28.6063858,77.0358091),
    LatLng(28.6064054,77.0357825),
    LatLng(28.6064278,77.0357584),
    LatLng(28.6064514,77.0357433),
    LatLng(28.6064897,77.0357292),
    LatLng(28.6065178,77.0357237),
    LatLng(28.6065448,77.0357241),
    LatLng(28.6065603,77.0357258),
    LatLng(28.6065747,77.0357242),
    LatLng(28.6065974,77.0357181),
    LatLng(28.6066223,77.0357048),
    LatLng(28.6066503,77.0356902),
    LatLng(28.606695,77.0356686),
    LatLng(28.6067572,77.0356419),
    LatLng(28.6068196,77.0356187),
    LatLng(28.6068804,77.0355946),
    LatLng(28.6069438,77.0355715),
    LatLng(28.6070092,77.0355525),
    LatLng(28.6070742,77.0355325),
    LatLng(28.6071267,77.0355105),
    LatLng(28.6071589,77.0354937),
    LatLng(28.6071774,77.0354864),
    LatLng(28.6071963,77.0354789),
    LatLng(28.6072067,77.0354738),
    LatLng(28.6072233,77.0354662),
    LatLng(28.6072439,77.0354605),
    LatLng(28.6072748,77.0354537),
    LatLng(28.6073038,77.0354471),
    LatLng(28.6073419,77.0354352),
    LatLng(28.6073805,77.0354237),
    LatLng(28.607439,77.0354058),
    LatLng(28.6075023,77.0353875),
    LatLng(28.6075671,77.035368),
    LatLng(28.6076273,77.0353488),
    LatLng(28.6076902,77.0353264),
    LatLng(28.6077573,77.0353065),
    LatLng(28.6078197,77.0352888),
    LatLng(28.6078769,77.0352772),
    LatLng(28.6079318,77.0352649),
    LatLng(28.6079876,77.0352427),
    LatLng(28.6080468,77.0352145),
    LatLng(28.6081111,77.0351857),
    LatLng(28.6081826,77.0351606),
    LatLng(28.6082491,77.0351369),
    LatLng(28.608301,77.03512),
    LatLng(28.6083367,77.0351091),
    LatLng(28.6083617,77.0351023),
    LatLng(28.6083879,77.035096),
    LatLng(28.608412,77.0350935),
    LatLng(28.6084496,77.0350886),
    LatLng(28.6084872,77.0350823),
    LatLng(28.608549,77.0350657),
    LatLng(28.6086056,77.0350426),
    LatLng(28.6086607,77.035018),
    LatLng(28.6087209,77.0349955),
    LatLng(28.608784,77.0349712),
    LatLng(28.6088443,77.0349494),
    LatLng(28.6089006,77.0349285),
    LatLng(28.608937,77.0349132),
    LatLng(28.6089625,77.034898),
    LatLng(28.6089955,77.0348817),
    LatLng(28.6090313,77.0348669),
    LatLng(28.6090711,77.0348517),
    LatLng(28.6091161,77.0348379),
    LatLng(28.6091634,77.0348239),
    LatLng(28.6092151,77.034808),
    LatLng(28.6092711,77.0347895),
    LatLng(28.6093329,77.0347667),
    LatLng(28.6094005,77.0347412),
    LatLng(28.6094745,77.0347156),
    LatLng(28.6095532,77.0346896),
    LatLng(28.6096376,77.034661),
    LatLng(28.6097231,77.0346336),
    LatLng(28.609808,77.0346069),
    LatLng(28.6098969,77.0345791),
    LatLng(28.6099902,77.0345499),
    LatLng(28.610087,77.0345169),
    LatLng(28.6101836,77.0344854),
    LatLng(28.6102817,77.0344554),
    LatLng(28.6103795,77.0344211),
    LatLng(28.6104802,77.0343857),
    LatLng(28.6105815,77.0343525),
    LatLng(28.6106856,77.034319),
    LatLng(28.6107918,77.034285),
    LatLng(28.6108988,77.0342546),
    LatLng(28.6110074,77.0342259),
    LatLng(28.6111152,77.0341944),
    LatLng(28.6112203,77.034157),
    LatLng(28.6113281,77.0341177),
    LatLng(28.6114402,77.0340778),
    LatLng(28.6115527,77.034042),
    LatLng(28.6116606,77.0340114),
    LatLng(28.6117649,77.03398),
    LatLng(28.6118638,77.0339516),
    LatLng(28.6119566,77.033927),
    LatLng(28.6120395,77.0339008),
    LatLng(28.6121199,77.0338681),
    LatLng(28.6122012,77.0338305),
    LatLng(28.6122896,77.0337976),
    LatLng(28.6123811,77.0337687),
    LatLng(28.6124705,77.0337386),
    LatLng(28.6125626,77.0337074),
    LatLng(28.6126582,77.0336777),
    LatLng(28.6127546,77.0336489),
    LatLng(28.6128457,77.0336207),
    LatLng(28.6129278,77.0335961),
    LatLng(28.6130019,77.0335736),
    LatLng(28.6130641,77.0335548),
    LatLng(28.6131199,77.0335359),
    LatLng(28.6131722,77.0335162),
    LatLng(28.6132183,77.0335001),
    LatLng(28.6132392,77.0334934),
    LatLng(28.6132761,77.0334838),
    LatLng(28.6133056,77.0334751),
    LatLng(28.6133399,77.0334609),
    LatLng(28.6133804,77.0334473),
    LatLng(28.6134262,77.0334383),
    LatLng(28.613473,77.0334296),
    LatLng(28.6135192,77.0334179),
    LatLng(28.6135704,77.0334045),
    LatLng(28.6136241,77.0333867),
    LatLng(28.6136806,77.0333591),
    LatLng(28.6137399,77.033333),
    LatLng(28.613806,77.0333143),
    LatLng(28.6138738,77.033299),
    LatLng(28.6139395,77.0332841),
    LatLng(28.6140031,77.0332662),
    LatLng(28.6140703,77.0332451),
    LatLng(28.6141343,77.0332202),
    LatLng(28.6141993,77.0331923),
    LatLng(28.6142624,77.0331617),
    LatLng(28.6143302,77.0331357),
    LatLng(28.614392,77.0331121),
    LatLng(28.6144474,77.0330892),
    LatLng(28.6144992,77.0330678),
    LatLng(28.6145534,77.0330484),
    LatLng(28.6146115,77.0330304),
    LatLng(28.6146711,77.0330105),
    LatLng(28.6147315,77.0329899),
    LatLng(28.6147896,77.0329753),
    LatLng(28.614841,77.0329608),
    LatLng(28.6148839,77.0329473),
    LatLng(28.6149173,77.0329372),];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates("AIzaSyBVfX9VirrOxTdHt9N71RH6wcBVKlZRXgY",
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,

    );

    if(result.points.isNotEmpty){
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
        LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
    print("my points");
    print(result.points);

  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track order",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: sourceLocation,
          zoom: 13.5,
        ),
        mapType: MapType.none,
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 6,
          )
        },
        markers: {
           Marker(
          markerId: MarkerId("source"),
          position: sourceLocation,
            infoWindow: InfoWindow(
              title: 'Start Point',
              snippet: '---',
            ),
        ),
           Marker(
            markerId: MarkerId("destination"),
            position: destination,
            infoWindow: InfoWindow(
              title: 'End Point',
              snippet: '---'
            ),
          ),
        }



      )
    );
  }
}
