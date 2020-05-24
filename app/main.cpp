#include <iostream>
#include <chrono>
#include <thread>

#include <render/Model.h>
#include <engine/Scene.h>

#include <env/env.h>
#include <render/Label.h>
#include "view/widgets/StackWidget.h"
#include "view/materials/CardMaterial.h"
#include "model/board/GameBoard.h"

int main() {
    auto window = env_setup_window();
    if (window == nullptr) {
        return -1;
    }

     auto f = make_shared<Font>(Font::LoadFace("../assets/fonts/Roboto-Medium.ttf", 48));

    auto l = Label(f);
    l.setText("Sample text!");

    env_setup_debug();

    auto camera = make_unique<Camera>(
            glm::perspective(glm::radians(65.f), 1600.f / 1200.f, 0.1f, 100.f),
            glm::vec3(0, 1.2f, 0),
            glm::normalize(glm::vec3(0, -1, -0.01f))
    );
    auto scene = make_unique<Scene>();

    auto board_model = Model::Load("../assets/gameboard", "game_board.obj");
    auto board_view = scene->addChild(GameBoardView(make_shared<Model>(move(board_model))));
    board_view->position = glm::vec3(0, -0.1f, 0);

    auto cards_tile = make_shared<Texture2D>(Texture2D("../assets/cards/3931.jpg"));
    auto card_tex = make_shared<Texture2D>(Texture2D("../assets/card/back.jpg"));
    auto card_material = make_shared<CardMaterial>(CardMaterial::Card(card_tex));
    card_material->tile_tex = cards_tile;

    auto card_model = make_shared<Model>(Model::Load("../assets/card", "base_card.obj", card_material));
    CardView::SharedModel = card_model;

    auto gameboard = GameBoard(board_view);
    gameboard.view->addSlot("corp_servers", glm::vec3(0, 0.01f, 0.62f), glm::vec4(-0.8f, -1.f, -0.05f, 1.f));
    gameboard.push("corp_servers", Card());
    auto card = gameboard.push("corp_servers", Card());
    card->faceup = false;
    gameboard.push("corp_servers", Card());

    /*
    auto stack = board_view->addChild(StackWidget());
    stack->position = glm::vec3(0, 0.01f, 0.62f);
    stack->alignment = StackWidgetAlignment_Max;
    stack->bounding_box = glm::vec4(-0.8f, -1.f, -0.05f, 1.f);
     */


    while (!glfwWindowShouldClose(window)) {
        scene->updateHierarchy();

        glClearColor(0.1f, 0.1f, 0.1f, 1.f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
        //glPolygonMode( GL_FRONT_AND_BACK, GL_LINE );

        {
            glEnable(GL_CULL_FACE);
            glEnable(GL_DEPTH_TEST);
            scene->drawFrom(*camera);
            //l.draw();
            glDisable(GL_DEPTH_TEST);
            glDisable(GL_CULL_FACE);
        }


        std::this_thread::sleep_for(std::chrono::milliseconds(16));
        glfwSwapBuffers(window);
        glfwPollEvents();

        if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
            glfwTerminate();
            return 0;
        }
    }
    return 0;
}
