package main.java.com.example.animals;

public class Counter implements AutoCloseable {
    private int count;
    private boolean isOpen;

    public Counter() {
        this.count = 0;
        this.isOpen = true;
    }

    public void add() throws IllegalStateException {
        if (!isOpen) {
            throw new IllegalStateException("Счетчик закрыт и не может быть использован.");
        }
        count++;
    }

    public int getCount() {
        return count;
    }

    @Override
    public void close() throws Exception {
        this.isOpen = false;
        System.out.println("Счетчик успешно закрыт. Текущее значение: " + count);
    }

    public boolean isOpen() {
        return isOpen;
    }
}