class Customer {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;
  final String type;

  Customer(this.id, this.name, this.phoneNumber, this.email,
      this.type);
  // factory Customer.fromJson(Map<String, dynamic> json) {
  //   try {
  //     return Customer(
  //       json['id'],
  //       "https://server.safacab.com/${json['image']}",
  //       //"https://images.unsplash.com/photo-1544502062-f82887f03d1c?q=80&w=3359&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  //       json['type'],
  //       int.parse(json['model']),
  //       json['driver_name'],
  //       json['number_plate'],
  //       json['seating_capacity'],
  //       json['luggage_capacity'],
  //     );
  //   }catch(error){
  //     print(error);
  //     return Customer(-1,"","","","","");
  //   }
  //}
}
