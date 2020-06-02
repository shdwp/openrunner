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
    unique_ptr<std::unordered_map<int, bool>> key_states_;
    unique_ptr<std::unordered_map<int, bool>> key_releases_;
    double cursorX_ = 0.0, cursorY_ = 0.0;

    explicit Input(GLFWwindow *);

    void keyUpdated(int, int);
    void mouseUpdated(double xpos, double ypos);

    static void KeyCallback(GLFWwindow *, int, int, int, int);
    static void MouseCallback(GLFWwindow *, double, double);
    static void MouseButtonCallback(GLFWwindow *, int, int, int);

public:
    [[nodiscard]] double getCursorX() const;
    [[nodiscard]] double getCursorY() const;

    bool keyPressed(int);
    bool keyDown(int);
    void reset();

    static Input* Shared;

    static void Setup(GLFWwindow *window) {
        Shared = new Input(window);
    }
};

#endif //OPENRUNNER_INPUT_H
