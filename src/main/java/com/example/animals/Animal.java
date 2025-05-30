package main.java.com.example.animals;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Animal {
    private int id;
    private String name;
    private LocalDate birthDate;
    private List<String> commands;

    public Animal(String name, LocalDate birthDate) {
        this.name = name;
        this.birthDate = birthDate;
        this.commands = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public List<String> getCommands() {
        return commands;
    }

    public void addCommand(String command) {
        if (command != null && !command.trim().isEmpty()) {
            this.commands.add(command);
        }
    }

    public void setCommands(List<String> commands) {
        this.commands = commands;
    }
}