class Meal {
  final int id;
  final String title;
  final String imageUrl;

  Meal({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    // Construct the imageUrl based on the id from the map
    String imageUrl = 'https://img.spoonacular.com/recipes/${map['id']}-556x370.jpg';

    return Meal(
      id: map['id'],
      title: map['title'],
      imageUrl: imageUrl,
    );
  }
}


// 'https://img.spoonacular.com/recipes/' + map['image']

// https://img.spoonacular.com/recipes/1697885-556x370.jpg