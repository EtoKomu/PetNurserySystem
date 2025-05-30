package main.java.com.example.animals;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.InputMismatchException;
import java.util.List;
import java.util.Scanner;

public class Main {
    private static AnimalRegistry registry = new AnimalRegistry();
    private static Scanner scanner = new Scanner(System.in);
    private static DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public static void main(String[] args) {
        runMenu();
    }

    private static void runMenu() {
        int choice;
        do {
            displayMenu();
            choice = getIntInput("Введите ваш выбор: ");
            switch (choice) {
                case 1:
                    addNewAnimalMenuItem();
                    break;
                case 2:
                    listAllAnimalsMenuItem();
                    break;
                case 3:
                    displayCommandsMenuItem();
                    break;
                case 4:
                    trainAnimalMenuItem();
                    break;
                case 0:
                    System.out.println("Выход из программы.");
                    break;
                default:
                    System.out.println("Неверный выбор. Пожалуйста, попробуйте снова.");
            }
        } while (choice != 0);
        scanner.close();
    }

    private static void displayMenu() {
        System.out.println("\n--- Реестр домашних животных ---");
        System.out.println("1. Завести новое животное");
        System.out.println("2. Показать всех животных");
        System.out.println("3. Увидеть список команд животного");
        System.out.println("4. Обучить животное новым командам");
        System.out.println("0. Выход");
        System.out.println("---------------------------------");
    }

    private static int getIntInput(String prompt) {
        while (true) {
            System.out.print(prompt);
            try {
                return scanner.nextInt();
            } catch (InputMismatchException e) {
                System.out.println("Ошибка: Введите число.");
                scanner.next();
            } finally {
                scanner.nextLine();
            }
        }
    }

    private static String getStringInput(String prompt) {
        System.out.print(prompt);
        return scanner.nextLine();
    }

    private static LocalDate getDateInput(String prompt) {
        while (true) {
            System.out.print(prompt + " (формат YYYY-MM-DD): ");
            String dateStr = scanner.nextLine();
            try {
                return LocalDate.parse(dateStr, dateFormatter);
            } catch (DateTimeParseException e) {
                System.out.println("Ошибка: Неверный формат даты. Пожалуйста, используйте YYYY-MM-DD.");
            }
        }
    }

    private static void addNewAnimalMenuItem() {
        try (Counter counter = new Counter()) {
            String name = getStringInput("Введите имя животного: ");
            String type = getStringInput("Введите тип животного (Собака, Кошка, Хомяк, Лошадь, Верблюд, Осел): ");
            LocalDate birthDate = getDateInput("Введите дату рождения животного: ");

            registry.addNewAnimal(name, type, birthDate);
            counter.add();
            System.out.println("Количество заведенных животных: " + counter.getCount());
        } catch (IllegalStateException e) {
            System.out.println("Ошибка счетчика: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Неизвестная ошибка со счетчиком: " + e.getMessage());
        }
    }

    private static void listAllAnimalsMenuItem() {
        List<Animal> animals = registry.getAllAnimals();
        if (animals.isEmpty()) {
            System.out.println("Реестр пуст.");
            return;
        }
        System.out.println("\n--- Список всех животных ---");
        for (Animal animal : animals) {
            System.out.println("Имя: " + animal.getName() + ", Дата рождения: " + animal.getBirthDate() + ", Команды: " + animal.getCommands());
        }
    }

    private static void displayCommandsMenuItem() {
        String name = getStringInput("Введите имя животного, чтобы увидеть его команды: ");
        registry.displayAnimalCommands(name);
    }

    private static void trainAnimalMenuItem() {
        String name = getStringInput("Введите имя животного для обучения: ");
        String command = getStringInput("Введите новую команду: ");
        registry.trainAnimal(name, command);
    }
}