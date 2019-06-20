class Profile {
  String phone;
  String lastName;
  String firstName;
  String email;
  String title;
  String skills;
  String image;

  Profile(
      {this.phone,
      this.lastName,
      this.firstName,
      this.email,
      this.title,
      this.skills,
      this.image});

  Profile.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    email = json['email'];
    title = json['title'];
    skills = json['skills'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['email'] = this.email;
    data['title'] = this.title;
    data['skills'] = this.skills;
    data['image'] = this.image;
    return data;
  }
}