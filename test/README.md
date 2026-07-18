# 🧪 Rider App Testing Guide

This guide explains the tests we've created and how to run them.

## 📁 Test Structure

```
test/
├── controllers/
│   ├── signup_controller_test.dart     # Tests registration logic
│   └── signin_controller_test.dart     # Tests login & verification
├── widgets/
│   └── error_sheet_test.dart           # Tests error display UI
└── README.md                            # This file
```

---

## 🎯 What Each Test Does

### 1. **SignUp Controller Tests** (`signup_controller_test.dart`)

**What it tests:**
- ✅ Step navigation (moving forward/backward through registration steps)
- ✅ Form reset (clearing all data when starting over)
- ✅ OTP timer initialization

**Why it matters:**
- Ensures users can navigate registration smoothly
- Prevents bugs where users get stuck on a step
- Validates that form resets properly when creating a new account

**Key tests:**
```dart
✓ should start at step 0
✓ should move to next step
✓ should NOT go beyond step 2
✓ should move to previous step
✓ should NOT go below step 0
✓ should reset all form fields
✓ should reset password visibility
```

---

### 2. **SignIn Controller Tests** (`signin_controller_test.dart`)

**What it tests:**
- ✅ Email verification error detection
- ✅ Password visibility toggle

**Why it matters:**
- Correctly identifies when a user needs to verify their email
- Shows verification dialog instead of generic error
- Ensures password show/hide works properly

**Key tests:**
```dart
✓ should detect "email not verified" error
✓ should detect "please verify your email"
✓ should detect "unverified" in message
✓ should detect "verification required"
✓ should work regardless of case (UPPERCASE/lowercase)
✓ should NOT detect regular errors as verification errors
✓ should toggle password visibility
```

---

### 3. **Error Sheet Widget Tests** (`error_sheet_test.dart`)

**What it tests:**
- ✅ Error sheet displays correct title and message
- ✅ Default "Try Again" button appears
- ✅ Custom button text works
- ✅ Tapping button closes the sheet

**Why it matters:**
- Ensures error messages are visible to users
- Validates that users can dismiss errors
- Tests the UI we use throughout the app

**Key tests:**
```dart
✓ should display error sheet with title and message
✓ should show default "Try Again" button
✓ should show custom button text when provided
✓ should close when button is tapped
```

---

## 🚀 Running the Tests

### Run ALL tests:
```bash
flutter test
```

**Output:**
```
00:02 +1: SignUp Controller Tests should start at step 0
00:02 +2: SignUp Controller Tests should move to next step
00:02 +3: SignUp Controller Tests should NOT go beyond step 2
...
00:05 +15: All tests passed!
```

---

### Run a specific test file:
```bash
# Test only signup controller
flutter test test/controllers/signup_controller_test.dart

# Test only signin controller
flutter test test/controllers/signin_controller_test.dart

# Test only error sheet
flutter test test/widgets/error_sheet_test.dart
```

---

### Run with coverage report:
```bash
flutter test --coverage
```

This creates a `coverage/lcov.info` file showing which code is tested.

---

### Run tests in verbose mode (see more details):
```bash
flutter test --reporter expanded
```

**Output:**
```
✓ SignUp Controller Tests should start at step 0 (12ms)
✓ SignUp Controller Tests should move to next step (8ms)
✓ SignUp Controller Tests should NOT go beyond step 2 (6ms)
...
```

---

## 📊 Understanding Test Output

### ✅ Passing Test:
```
00:02 +1: SignUp Controller Tests should start at step 0
```
- `00:02` = Time elapsed
- `+1` = 1 test passed
- Green checkmark ✓

### ❌ Failing Test:
```
00:03 +1 -1: SignUp Controller Tests should move to next step
  Expected: 1
  Actual: 0
```
- `+1 -1` = 1 passed, 1 failed
- Shows expected vs actual values
- Red X ✗

---

## 🧩 Test Anatomy Explained

Every test follows the **AAA Pattern**:

### 1. **ARRANGE** (Setup)
```dart
// Create the controller
final controller = SignUpController();
controller.currentStep = 0;
```
**What it does:** Prepares the test environment

---

### 2. **ACT** (Action)
```dart
// Perform the action we're testing
controller.nextStep();
```
**What it does:** Executes the code we want to test

---

### 3. **ASSERT** (Check)
```dart
// Verify the result
expect(controller.currentStep, 1);
```
**What it does:** Confirms the result is correct

---

## 🔍 Key Testing Concepts

### `expect()` - Assertion
```dart
expect(actual, expected)
```
**Examples:**
```dart
expect(controller.currentStep, 0);           // Should be 0
expect(controller.emailController.text, ''); // Should be empty
expect(controller.isOnline, true);           // Should be true
expect(controller.selectedCourierType, null); // Should be null
```

---

### `findsOneWidget` - Widget Assertions
```dart
expect(find.text('Registration Failed'), findsOneWidget);
```
**Meaning:** There should be exactly 1 widget with this text

**Other options:**
```dart
findsNothing      // Widget should NOT exist
findsWidgets      // Any number of widgets (1 or more)
findsNWidgets(2)  // Exactly 2 widgets
```

---

### `tester.tap()` - Simulating User Actions
```dart
await tester.tap(find.text('Show Error'));
await tester.pumpAndSettle();
```
**What it does:**
1. Finds the widget with text "Show Error"
2. Simulates a tap on it
3. Waits for all animations to complete

---

### `group()` - Organizing Tests
```dart
group('Step Navigation Tests', () {
  test('should move to next step', () { ... });
  test('should move to previous step', () { ... });
});
```
**Purpose:** Groups related tests together for better organization

---

## 🎨 Test Best Practices We're Following

### ✅ Clear Test Names
```dart
// GOOD ✓
test('should move to next step when nextStep is called', () { ... });

// BAD ✗
test('test1', () { ... });
```

---

### ✅ One Thing Per Test
Each test checks ONE specific behavior:
```dart
// GOOD ✓
test('should move to next step', () { ... });
test('should NOT go beyond max step', () { ... });

// BAD ✗ (testing multiple things)
test('step navigation works', () {
  // Tests next, previous, max, min all in one test
});
```

---

### ✅ Descriptive Assertions
```dart
// GOOD ✓
expect(controller.currentStep, 1, 
  reason: 'Step should increment by 1');

// GOOD ✓ (our approach)
// We use clear test names instead of reason parameter
test('should move from step 0 to step 1', () { ... });
```

---

## 🐛 Debugging Failed Tests

### If a test fails:

1. **Read the error message:**
```
Expected: 1
Actual: 0
```
This means the code returned 0 but we expected 1.

2. **Check the test setup:**
- Did you initialize the controller correctly?
- Are you starting with the right values?

3. **Add debug prints:**
```dart
test('should move to next step', () {
  final controller = SignUpController();
  controller.currentStep = 0;
  
  print('Before: ${controller.currentStep}'); // Debug
  controller.nextStep();
  print('After: ${controller.currentStep}');  // Debug
  
  expect(controller.currentStep, 1);
});
```

4. **Run just that one test:**
```bash
flutter test test/controllers/signup_controller_test.dart \
  --plain-name "should move to next step"
```

---

## 📈 What Should Be Tested?

### ✅ ALWAYS Test:
- Business logic (controllers, services)
- Critical user flows (registration, login, payment)
- Bug fixes (write a test that would have caught the bug)
- Error handling (what happens when things go wrong)

### ⚠️ SOMETIMES Test:
- UI widgets (if they're complex or reused)
- Utilities and helpers
- Data models (if they have logic)

### ❌ DON'T Bother Testing:
- Third-party packages (they have their own tests)
- Simple getters/setters
- Generated code (like .g.dart files)

---

## 🎯 Next Steps

### To add more tests:

1. **Create a new test file:**
```bash
touch test/controllers/deliveries_controller_test.dart
```

2. **Follow the same pattern:**
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Delivery Tests', () {
    test('should accept delivery', () {
      // ARRANGE
      // ACT
      // ASSERT
    });
  });
}
```

3. **Run it:**
```bash
flutter test test/controllers/deliveries_controller_test.dart
```

---

## 🏆 Test Coverage Goals

| Component | Current | Target |
|-----------|---------|--------|
| Controllers | ~40% | 80% |
| Services | ~20% | 70% |
| Widgets | ~10% | 50% |
| **Overall** | **~25%** | **70%** |

---

## 💡 Common Questions

### Q: How long do tests take?
**A:** Very fast! All our tests run in ~5 seconds.

### Q: Do I need to test every line of code?
**A:** No! Focus on business logic and critical flows.

### Q: What if I change the code?
**A:** Update the tests! Tests should evolve with your code.

### Q: Should I write tests before or after coding?
**A:** Either works! Some prefer **TDD** (Test-Driven Development) where you write tests first. Others write tests after. Both are valid.

---

## 🔗 Resources

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [GetX Testing](https://github.com/jonataslaw/getx#testing)

---

**Remember:** Tests are like a safety net. They catch bugs before users do! 🚀
