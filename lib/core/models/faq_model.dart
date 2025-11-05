class FaqDataModel {
  final String name;
  final List<FaqItem> faqs;

  FaqDataModel({required this.name, required this.faqs});

  factory FaqDataModel.fromJson(Map<String, dynamic> json) {
    var faqList = json['faqs'] as List;
    List<FaqItem> faqItems = faqList.map((faq) => FaqItem.fromJson(faq)).toList();

    return FaqDataModel(
      name: json['name'] as String,
      faqs: faqItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'faqs': faqs.map((faq) => faq.toJson()).toList(),
    };
  }
}

class FaqItem {
  final int id;
  final String question;
  final String answer;
  final int categoryId;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoryId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
      categoryId: json['category_id'] as int,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category_id': categoryId,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
