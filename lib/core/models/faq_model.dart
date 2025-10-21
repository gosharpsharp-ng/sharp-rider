class FAQModel {
  final int id;
  final String question;
  final String answer;
  final String? category;
  final int? order;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  FAQModel({
    required this.id,
    required this.question,
    required this.answer,
    this.category,
    this.order,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      category: json['category'],
      order: json['order'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'order': order,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
