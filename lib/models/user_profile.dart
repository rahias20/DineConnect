class UserProfile {
  final String userId;
  final String name;
  final int age;
  final String bio;
  final String lookingFor;
  final String? imageUrl;
  final String location;
  final List<String> hobbies;

  UserProfile({
    required this.userId,
    required this.name,
    required this.age,
    required this.bio,
    required this.lookingFor,
    this.imageUrl,
    required this.location,
    required this.hobbies,
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'bio': bio,
      'lookingFor': lookingFor,
      'imageUrl': imageUrl,
      'location': location,
      'hobbies': hobbies
    };
  }

  // construct user profile from a map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
        userId: map['userId'],
        name: map['name'],
        age: map['age'],
        bio: map['bio'],
        lookingFor: map['lookingFor'],
        imageUrl: map['imageUrl'] as String?, // cast as String since it can be null
        location: map['location'],
        hobbies: List<String>.from(map['hobbies']));
  }
}
