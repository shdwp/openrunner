//
// Created by shdwp on 5/31/2020.
//

#include "ui/Input.h"
#include <functional>

Input* Input::Shared = nullptr;

void Input::KeyCallback(GLFWwindow *window, int key, int scancode, int action, int mods) {
    Input::Shared->keyUpdated(key, action);
}

void Input::MouseCallback(GLFWwindow *window, double xpos, double ypos) {
    Input::Shared->mouseUpdated(xpos, ypos);
}

void Input::ScrollCallback(GLFWwindow *window, double xpos, double ypos) {
    Input::Shared->scrollUpdated(xpos, ypos);
}

void Input::MouseButtonCallback(GLFWwindow *, int button, int action, int mods) {
    Input::Shared->keyUpdated(button, action);
}

void Input::keyUpdated(int key, int action) {
    if ((*key_states_)[key] && action == GLFW_RELEASE) {
        (*key_releases_)[key] = true;
    }

    if (!(*key_states_)[key] && action == GLFW_PRESS) {
        (*key_presses_)[key] = true;
    }

    (*key_states_)[key] = (action == GLFW_PRESS) || (action == GLFW_REPEAT);
}

void Input::mouseUpdated(double xpos, double ypos) {
    cursorX_ = xpos;
    cursorY_ = ypos;
}

void Input::scrollUpdated(double xpos, double ypos) {
    scrollX_ = xpos;
    scrollY_ = ypos;
}

Input::Input(GLFWwindow *window) {
    window_ = window;
    key_states_ = make_unique<std::unordered_map<int, bool>>();
    key_releases_ = make_unique<std::unordered_map<int, bool>>();

    glfwSetKeyCallback(window, &Input::KeyCallback);
    glfwSetMouseButtonCallback(window, &Input::MouseButtonCallback);
    glfwSetCursorPosCallback(window, &Input::MouseCallback);
    glfwSetScrollCallback(window, &Input::ScrollCallback);
}

bool Input::keyPressed(int key) {
    if ((*key_presses_)[key]) {
        (*key_presses_)[key] = false;
        return true;
    } else {
        return false;
    }
}

bool Input::keyReleased(int key) {
    if ((*key_releases_)[key]) {
        (*key_releases_)[key] = false;
        return true;
    } else {
        return false;
    }
}

bool Input::keyDown(int key) {
    return (*key_states_)[key];
}

void Input::reset() {
    key_releases_->erase(key_releases_->begin(), key_releases_->end());
    key_presses_->erase(key_presses_->begin(), key_presses_->end());
    scrollX_ = 0.0;
    scrollY_ = 0.0;
}

double Input::getCursorX() const {
    return cursorX_;
}

double Input::getCursorY() const {
    return cursorY_;
}

double Input::getScrollX() const {
    return scrollX_;
}

double Input::getScrollY() const {
    return scrollY_;
}
