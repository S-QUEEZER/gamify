// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, prefer_typing_uninitialized_variables

class HealthModel {
  final sugar_g,
      fiber_g,
      sodium_mg,
      potassium_mg,
      fat_saturated_g,
      fat_total_g,
      calories,
      cholesterol_mg,
      protein_g,
      carbohydrates_total_g;
  String? postId;
  double? serving_size_g;
  String? username, emailId;
  String? name;
  String uid;
  DateTime? createdAt;

  HealthModel(
      {required this.sugar_g,
      required this.fiber_g,
      this.serving_size_g,
      required this.sodium_mg,
      required this.name,
      this.postId,
      this.createdAt,
      required this.potassium_mg,
      required this.fat_saturated_g,
      required this.fat_total_g,
      required this.calories,
      required this.cholesterol_mg,
      required this.protein_g,
      required this.carbohydrates_total_g,
      required this.uid});

  Map<String, dynamic> toJson() => {
        'fiber': fiber_g,
        'uid': uid,
        'sodium': sodium_mg,
        'protein': protein_g,
        'fat_total_g': fat_total_g,
        'carbs': carbohydrates_total_g,
        'calories': calories,
        'createdAt': DateTime.now(),
        'fat_saturated_g': fat_saturated_g,
        "cholesterol": cholesterol_mg,
        "sugar": sugar_g,
        "potassium": potassium_mg,
        "createdAt": createdAt,
        "name": name,
        "day": 'Wednesday',
        "serving_size_g": serving_size_g,
        "postId": postId
      };
}
