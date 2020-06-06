#include <iostream>
#include <chrono>
#include <thread>

#include <render/Model.h>
#include <engine/Scene.h>
#include <env/env.h>
#include <scripting/LuaHost.h>
#include <ui/Input.h>
#include <util/Debug.h>
#include <ui/UILayer.h>

#include "controller/Scripting.h"
#include "view/widgets/StackWidget.h"
#include "view/materials/CardMaterial.h"
#include "model/board/GameBoard.h"
#include "view/widgets/ActionWidget.h"

int main() {
    auto window = env_setup_window();
    if (window == nullptr) {
        return -1;
    }

    env_setup_debug();

    Input::Setup(window);
    Debug::Setup();

    auto font = make_shared<Font>(Font::LoadFace("../assets/fonts/Roboto-Medium.ttf", 32));
    auto cursor_proj = glm::ortho(0.f, 800.f, 600.f, 0.f);

    /** game scene **/
    auto scene = make_unique<Scene>(Camera(
            glm::perspective(glm::radians(65.f), 1600.f / 1200.f, 0.1f, 100.f),
            glm::vec3(0, 1.2f, 0.3f),
            glm::normalize(glm::vec3(0, -1, -0.01f))
    ), cursor_proj);
    auto board_model = make_shared<Model>(Model::Load("../assets/gameboard", "game_board.obj"));
    auto card_tex = make_shared<Texture2D>(Texture2D("../assets/card/back.jpg"));
    auto card_material = make_shared<CardMaterial>(CardMaterial::Material(card_tex));

    auto card_model = make_shared<Model>(Model::Load("../assets/card", "base_card.obj", card_material));
    CardView::SharedMaterial = card_material;
    CardView::SharedModel = card_model;

    /** gui scene **/
    auto gui_scene = make_unique<Scene>(Camera(
            glm::ortho(0.f, 800.f, 0.f, 600.f, -100.f, 100.f),
            glm::vec3(0.f, 0.f, 0.f),
            glm::normalize(glm::vec3(0.f, 0.0f, -1.f))
    ), cursor_proj);
    gui_scene->position = glm::vec3(400.f, 300.f, 0.f);

    shared_ptr<GameBoardView> board_view = nullptr;
    shared_ptr<GameBoardView> hand_view = nullptr;
    unique_ptr<Scripting> scripting = nullptr;

    while (!glfwWindowShouldClose(window)) {
        INFO("Game begin");
        scene->reset();
        gui_scene->reset();

        auto status_label = make_shared<Label>(font);
        status_label->setText("Test label");
        status_label->position = glm::vec3(-100.f, 270.f, 0.f);
        gui_scene->addChild(status_label);

        auto gui_card_zoomed_view = make_shared<CardView>(card_model);
        gui_card_zoomed_view->scale = glm::vec3(250.f);
        gui_scene->addChild(gui_card_zoomed_view);

        board_view = scene->addChild(GameBoardView(board_model));
        board_view->position = glm::vec3(0.f, 0.f, 0.f);
        board_view->addModelSlots();

        float hand_scale = 500.f;
        hand_view = gui_scene->addChild(GameBoardView());
        hand_view->addSlot("corp_hand", glm::vec3(0.f), glm::vec4(-300.f, 250.f, 300.f, 250.f) * (1.f / hand_scale));
        hand_view->rotation = glm::rotate(hand_view->rotation, glm::vec3((float)M_PI_2, 0.0f, 0.f));
        hand_view->scale = glm::vec3(hand_scale);

        auto gameboard = GameBoard();
        gameboard.addView(board_view);
        gameboard.addView(hand_view);

        scripting = make_unique<Scripting>();
        scripting->registerClasses();
        scripting->setGlobal("board", &gameboard);
        scripting->setGlobal("hand_view", hand_view.get());
        scripting->setGlobal("board_view", board_view.get());
        scripting->setGlobal("status_label", status_label.get());
        scripting->doScripts("../app/scripts");
        scripting->onInit();

        while (!glfwWindowShouldClose(window)) {
            glClearColor(0.1f, 0.1f, 0.1f, 1.f);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
            //glPolygonMode( GL_FRONT_AND_BACK, GL_LINE );

            scene->updateHierarchy();
            // @TODO: fixme
            gui_card_zoomed_view->rotation = glm::rotate(gui_card_zoomed_view->rotation, glm::vec3((float)M_PI_2, 0.f, 0.f));

            scripting->onTick(glfwGetTime());

            {
                scene->bind();
                glEnable(GL_CULL_FACE);
                glEnable(GL_DEPTH_TEST);
                scene->drawHierarchy(glm::identity<glm::mat4>());
                glDisable(GL_DEPTH_TEST);
                glDisable(GL_CULL_FACE);
                scene->unbind();
            }

            gui_scene->updateHierarchy();

            {
                gui_scene->bind();
                glEnable(GL_CULL_FACE);
                glEnable(GL_DEPTH_TEST);
                gui_scene->drawHierarchy(glm::identity<glm::mat4>());
                glDisable(GL_DEPTH_TEST);
                glDisable(GL_CULL_FACE);
                gui_scene->unbind();
            }

            scene->ui_layer->debugDraw();
            gui_scene->ui_layer->debugDraw();

            std::this_thread::sleep_for(std::chrono::milliseconds(32));
            glfwSwapBuffers(window);
            glfwPollEvents();

            if (Input::Shared->keyPressed(GLFW_MOUSE_BUTTON_LEFT)) {
                shared_ptr<UIInteractable> intr;
                if ((intr = gui_scene->ui_layer->traceInputCursor()) || (intr = scene->ui_layer->traceInputCursor())) {
                    scripting->onInteraction(InteractionEvent_Click, intr);
                }
            }

            if (Input::Shared->keyPressed(GLFW_MOUSE_BUTTON_RIGHT)) {
                shared_ptr<UIInteractable> intr;
                if ((intr = gui_scene->ui_layer->traceInputCursor()) || (intr = scene->ui_layer->traceInputCursor())) {
                    scripting->onInteraction(InteractionEvent_AltClick, intr);
                }
            }

            if (Input::Shared->keyPressed(GLFW_KEY_R)) {
                // force game restart
                break;
            }

            if (Input::Shared->keyDown(GLFW_KEY_LEFT_ALT)) {
                shared_ptr<UIInteractable> intr;
                if ((intr = gui_scene->ui_layer->traceInputCursor()) || (intr = scene->ui_layer->traceInputCursor())) {
                    if (auto card_view = dynamic_pointer_cast<CardView>(intr)) {
                        gui_card_zoomed_view->setItem(card_view->card);
                    }
                }
            } else {
                gui_card_zoomed_view->setItem<Card>(nullptr);
            }

            if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
                glfwTerminate();
                return 0;
            }

            Input::Shared->reset();
        }

        INFO("Game end");
    }

    // @TODO: run destructors on LuaRefs before LuaHost closes luaL
    return 0;
}
