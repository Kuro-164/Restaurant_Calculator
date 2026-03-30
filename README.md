# 🍽️ Restaurant Calculator App

A Flutter-based restaurant billing system with a **calculator-style interface** that allows quick item selection and bill generation.

---

## 🚀 Features

* Calculator-based price input
* Add items to cart easily
* Quantity management
* Fast and simple billing
* Clean and minimal UI

---

## ⚙️ Tech Stack

* Flutter
* Dart

---

## 📂 Project Structure

```
lib/
 ├── data/
 │    ├── menu_data.dart        # Main menu data (EDIT THIS)
 │    └── load_menu_data.dart   # Data loading logic
 │
 ├── models/
 │    ├── cart_item.dart
 │    ├── menu_item.dart
 │
 ├── screens/
 │    ├── billing_screen.dart
 │    ├── calculator_screen.dart
 │
 └── main.dart
```

---

## ⚠️ Important Note (MUST READ)

> Before running the app, you need to edit the menu data file.

👉 File to edit:

```
lib/data/menu_data.dart
```

### Why?

* This file currently contains **sample restaurant data**
* The app uses this data to display menu items

### What you should do:

* Replace item names with your restaurant items
* Update prices accordingly
* Customize menu as per your use case

⚠️ If not edited, the app will show default/sample data.

---

## ▶️ How to Run

1. Clone the repository
2. Run:

   ```
   flutter pub get
   ```
3. Edit `menu_data.dart` with your menu
4. Run:

   ```
   flutter run
   ```

---

## 📥 Download APK

Available in the Releases section.

---
