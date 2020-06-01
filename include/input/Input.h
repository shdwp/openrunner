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
    explicit Input(GLFWwindow *);

    void KeyUpdated(int, int);

    static void KeyCallback(GLFWwindow *, int, int, int, int);

public:
    bool keyPressed(int);
    bool keyDown(int);
    void reset();

    static Input* Shared;

    static void Setup(GLFWwindow *window) {
        Shared = new Input(window);
    }
};


#endif //OPENRUNNER_INPUT_H
