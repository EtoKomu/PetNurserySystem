package main.java.com.example.animals;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class AnimalRegistry {
    private List<Animal> animals;

    public AnimalRegistry() {
        this.animals = new ArrayList<>();
    }

    public void addNewAnimal(String name, String type, LocalDate birthDate) {
        Animal newAnimal = null;
        switch (type.toLowerCase()) {
            case "собака":
                newAnimal = new Dog(name, birthDate);
                break;
            case "кошка":
                newAnimal = new Cat(name, birthDate);
                break;
            case "хомяк":
                newAnimal = new Hamster(name, birthDate);
                break;
            case "лошадь":
                newAnimal = new Horse(name, birthDate);
                break;
            case "верблюд":
                newAnimal = new Camel(name, birthDate);
                break;
            case "осел":
                newAnimal = new Donkey(name, birthDate);
                break;
            default:
                System.out.println("Неизвестный тип животного.");
                return;
        }
        if (newAnimal != null) {
            animals.add(newAnimal);
            System.out.println("Животное " + name + " (" + type + ") успешно добавлено.");
        }
    }

    public Optional<Animal> findAnimalByName(String name) {
        return animals.stream()
                      .filter(a -> a.getName().equalsIgnoreCase(name))
                      .findFirst();
    }

    public void displayAnimalCommands(String animalName) {
        Optional<Animal> animalOpt = findAnimalByName(animalName);
        if (animalOpt.isPresent()) {
            Animal animal = animalOpt.get();
            System.out.println("Команды, которые выполняет " + animal.getName() + ": " + animal.getCommands());
        } else {
            System.out.println("Животное с именем " + animalName + " не найдено.");
        }
    }

    public void trainAnimal(String animalName, String newCommand) {
        Optional<Animal> animalOpt = findAnimalByName(animalName);
        if (animalOpt.isPresent()) {
            Animal animal = animalOpt.get();
            animal.addCommand(newCommand);
            System.out.println(animal.getName() + " теперь может выполнять команду '" + newCommand + "'.");
        } else {
            System.out.println("Животное с именем " + animalName + " не найдено.");
        }
    }

    public List<Animal> getAllAnimals() {
        return new ArrayList<>(animals);
    }
}