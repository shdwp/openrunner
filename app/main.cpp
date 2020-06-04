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
    auto cards_tile = make_shared<Texture2D>(Texture2D("../assets/cards/3931.jpg"));
    auto card_tex = make_shared<Texture2D>(Texture2D("../assets/card/back.jpg"));
    auto card_material = make_shared<CardMaterial>(CardMaterial::Card(card_tex));
    card_material->tile_tex = cards_tile;

    auto card_model = make_shared<Model>(Model::Load("../assets/card", "base_card.obj", card_material));
    CardView::SharedModel = card_model;

    /** gui scene **/
    auto gui_scene = make_unique<Scene>(Camera(
            glm::ortho(0.f, 800.f, 0.f, 600.f, -100.f, 100.f),
            glm::vec3(0.f, 0.f, 0.f),
            glm::normalize(glm::vec3(0.f, 0.0f, -1.f))
    ), cursor_proj);

    auto test_label = Label(font);
    test_label.setText("Test label");
    test_label.position = glm::vec3(0.f, 0.f, 0.f);
    gui_scene->addChild(move(test_label));

    shared_ptr<GameBoardView> board_view = nullptr;
    shared_ptr<GameBoardView> hand_view = nullptr;

    while (!glfwWindowShouldClose(window)) {
        INFO("Game begin");
        scene->reset();
        gui_scene->reset();

        board_view = scene->addChild(GameBoardView(board_model));
        board_view->position = glm::vec3(0.f, 0.f, 0.f);

        float hand_scale = 500.f;
        hand_view = gui_scene->addChild(GameBoardView());
        hand_view->addSlot("corp_hand", glm::vec3(0.f), glm::vec4(100.f, 50.f, 700.f, 50.f) * (1.f / hand_scale));
        hand_view->rotation = glm::rotate(hand_view->rotation, glm::vec3((float)-M_PI_2, (float)0.1f, 0.f));
        hand_view->scale = glm::vec3(hand_scale);

        auto gameboard = GameBoard();
        gameboard.addView(board_view);
        gameboard.addView(hand_view);

        auto scripting = make_unique<Scripting>();
        scripting->registerClasses();
        scripting->setGlobal("board", &gameboard);
        scripting->setGlobal("hand_view", hand_view.get());
        scripting->setGlobal("board_view", board_view.get());
        scripting->doScripts("../app/scripts");
        scripting->onInit();

        while (!glfwWindowShouldClose(window)) {
            glClearColor(0.1f, 0.1f, 0.1f, 1.f);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
            //glPolygonMode( GL_FRONT_AND_BACK, GL_LINE );

            scene->updateHierarchy();
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

            if (Input::Shared->keyDown(GLFW_MOUSE_BUTTON_LEFT)) {
                shared_ptr<UIInteractable> intr;
                auto a = gui_scene->ui_layer->traceInputCursor();
                auto b = scene->ui_layer->traceInputCursor();
                if ((intr = gui_scene->ui_layer->traceInputCursor()) || (intr = scene->ui_layer->traceInputCursor())) {
                    INFO("hit a {} b {}", a != nullptr, b != nullptr);
                }
            }

            std::this_thread::sleep_for(std::chrono::milliseconds(16));
            glfwSwapBuffers(window);
            glfwPollEvents();

            if (Input::Shared->keyPressed(GLFW_KEY_R)) {
                // force game restart
                break;
            }

            Input::Shared->reset();

            if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
                glfwTerminate();
                return 0;
            }
        }

        INFO("Game end");
    }

    return 0;
}
