#include <iostream>
#include <chrono>
#include <thread>

#include <render/Model.h>
#include <engine/Scene.h>
#include <env/env.h>
#include <scripting/LuaHost.h>
#include <input/Input.h>
#include <util/Debug.h>

#include "controller/Scripting.h"
#include "view/widgets/StackWidget.h"
#include "view/materials/CardMaterial.h"
#include "model/board/GameBoard.h"

int main() {
    auto window = env_setup_window();
    if (window == nullptr) {
        return -1;
    }

    env_setup_debug();

    Input::Setup(window);
    Debug::Setup();

    auto camera = make_unique<Camera>(
            glm::perspective(glm::radians(65.f), 1600.f / 1200.f, 0.1f, 100.f),
            glm::vec3(0, 1.2f, 0),
            glm::normalize(glm::vec3(0, -1, -0.01f))
    );
    auto scene = make_unique<Scene>();

    auto board_model = make_shared<Model>(Model::Load("../assets/gameboard", "game_board.obj"));

    auto cards_tile = make_shared<Texture2D>(Texture2D("../assets/cards/3931.jpg"));
    auto card_tex = make_shared<Texture2D>(Texture2D("../assets/card/back.jpg"));
    auto card_material = make_shared<CardMaterial>(CardMaterial::Card(card_tex));
    card_material->tile_tex = cards_tile;

    auto card_model = make_shared<Model>(Model::Load("../assets/card", "base_card.obj", card_material));
    CardView::SharedModel = card_model;

    auto scripting = make_unique<Scripting>();

    shared_ptr<GameBoardView> board_view = nullptr;

    while (!glfwWindowShouldClose(window)) {
        INFO("Game begin");
        if (board_view != nullptr) {
            scene->removeChild(board_view);
        }

        board_view = scene->addChild(GameBoardView(board_model));
        board_view->position = glm::vec3(0, -0.1f, 0);

        auto gameboard = GameBoard(board_view);

        scripting->setGlobal("board", &gameboard);
        scripting->doScripts("../app/scripts");

        while (!glfwWindowShouldClose(window)) {
            scene->updateHierarchy();
            scripting->onTick(glfwGetTime());

            glClearColor(0.1f, 0.1f, 0.1f, 1.f);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
            //glPolygonMode( GL_FRONT_AND_BACK, GL_LINE );

            {
                glEnable(GL_CULL_FACE);
                glEnable(GL_DEPTH_TEST);
                scene->drawFrom(*camera);
                glDisable(GL_DEPTH_TEST);
                glDisable(GL_CULL_FACE);
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
