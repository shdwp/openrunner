//
// Created by shdwp on 5/31/2020.
//

#ifndef OPENRUNNER_INPUT_H
#define OPENRUNNER_INPUT_H

#include <definitions.h>
#include <GLFW/glfw3.h>
#include <unordered_map>

class Input {
private:
    GLFWwindow *window_;
    unique_ptr<std::unordered_map<int, bool>> key_states_ = make_unique<std::unordered_map<int, bool>>();
    unique_ptr<std::unordered_map<int, bool>> key_releases_ = make_unique<std::unordered_map<int, bool>>();
    unique_ptr<std::unordered_map<int, bool>> key_presses_ = make_unique<std::unordered_map<int, bool>>();
    double cursorX_ = 0.0, cursorY_ = 0.0;
    double scrollX_ = 0.0, scrollY_ = 0.0;

    explicit Input(GLFWwindow *);

    void keyUpdated(int, int);
    void mouseUpdated(double, double);
    void scrollUpdated(double, double);

    static void KeyCallback(GLFWwindow *, int, int, int, int);
    static void MouseCallback(GLFWwindow *, double, double);
    static void MouseButtonCallback(GLFWwindow *, int, int, int);
    static void ScrollCallback(GLFWwindow *, double, double);

public:
    [[nodiscard]] double getCursorX() const;
    [[nodiscard]] double getCursorY() const;
    [[nodiscard]] double getScrollX() const;
    [[nodiscard]] double getScrollY() const;

    bool keyPressed(int);
    bool keyReleased(int);
    bool keyDown(int);
    void reset();

    static Input* Shared;

    static void Setup(GLFWwindow *window) {
        Shared = new Input(window);
    }
};

#endif //OPENRUNNER_INPUT_H
