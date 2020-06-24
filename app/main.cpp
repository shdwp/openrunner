#include <chrono>
#include <thread>

#include <render/Model.h>
#include <engine/Scene.h>
#include <env/env.h>
#include <scripting/LuaHost.h>
#include <ui/Input.h>
#include <util/Debug.h>
#include <ui/LayoutStack.h>

#include "controller/Scripting.h"
#include "model/board/GameBoard.h"
#include "view/board/ZoomCardView.h"
#include "view/widgets/CardSelectWidget.h"
#include "view/widgets/OptionSelectWidget.h"

int main() {
    auto window = env_setup_window();
    if (window == nullptr) {
        return -1;
    }

    env_setup_debug();

    Input::Setup(window);
    Debug::Setup();

    auto font = make_shared<Font>(Font::LoadFace("../assets/fonts/Roboto-Medium.ttf", 24));
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
    shared_ptr<GameBoardView> corp_hand_view = nullptr;
    shared_ptr<GameBoardView> runner_hand_view = nullptr;
    unique_ptr<Scripting> scripting = nullptr;

    while (!glfwWindowShouldClose(window)) {
        scene->reset();
        gui_scene->reset();

        auto test_widget = make_shared<LayoutStack>();
        test_widget->addChild(Entity());
        test_widget->addChild(Entity());
        gui_scene->addChild(test_widget);

        auto status_label = make_shared<Label>(font);
        status_label->setText("");
        status_label->position = glm::vec3(-400.f, 280.f, 0.f);
        gui_scene->addChild(status_label);

        auto alert_label = make_shared<Label>(font);
        alert_label->setText("alert label");
        alert_label->position = glm::vec3(80.f, 280.f, 0.f);
        gui_scene->addChild(alert_label);

        auto gui_card_zoomed_view = make_shared<ZoomCardView>(card_model);
        gui_card_zoomed_view->scale = glm::vec3(250.f);
        gui_scene->addChild(gui_card_zoomed_view);

        board_view = scene->addChild(GameBoardView(board_model));
        board_view->position = glm::vec3(0.f, 0.f, 0.f);
        board_view->addModelSlots();

        float hand_scale = 500.f;
        corp_hand_view = gui_scene->addChild(GameBoardView());
        corp_hand_view->addSlot("corp_hand", glm::vec3(0.f), glm::vec4(-300.f, 250.f, 300.f, 250.f) * (1.f / hand_scale));
        corp_hand_view->rotation = glm::rotate(corp_hand_view->rotation, glm::vec3((float)M_PI_2, 0.0f, 0.f));
        corp_hand_view->scale = glm::vec3(hand_scale);

        runner_hand_view = gui_scene->addChild(GameBoardView());
        runner_hand_view->addSlot("runner_hand", glm::vec3(0.f), glm::vec4(-300.f, 250.f, 300.f, 250.f) * (1.f / hand_scale));
        runner_hand_view->rotation = glm::rotate(runner_hand_view->rotation, glm::vec3((float)M_PI_2, 0.0f, 0.f));
        runner_hand_view->scale = glm::vec3(hand_scale);

        auto card_select_widget = make_shared<CardSelectWidget>();
        card_select_widget->rotation = glm::rotate(card_select_widget->rotation, glm::vec3((float)M_PI_2 + M_PI, 0.f, 0.f));
        card_select_widget->scale = glm::vec3(600.f);
        card_select_widget->hidden = true;
        gui_scene->addChild(card_select_widget);

        auto option_select_widget = make_shared<OptionSelectWidget>(font);
        option_select_widget->hidden = true;
        gui_scene->addChild(option_select_widget);

        auto gameboard = GameBoard();
        gameboard.addView(board_view);
        gameboard.addView(corp_hand_view);
        gameboard.addView(runner_hand_view);

        scripting = make_unique<Scripting>();
        scripting->registerClasses();
        scripting->doScript("../app/scripts_lib/native_interface.lua");

        scripting->setGlobal("main_camera", scene->camera.get());
        scripting->setGlobal("host", scripting.get());
        scripting->setGlobal("board", &gameboard);
        scripting->setGlobal("corp_hand_view", corp_hand_view.get());
        scripting->setGlobal("runner_hand_view", runner_hand_view.get());
        scripting->setGlobal("board_view", board_view.get());

        scripting->setGlobal("card_select_widget", card_select_widget.get());

        scripting->setGlobal("option_select_widget", option_select_widget.get());
        scripting->setGlobal("status_label", status_label.get());
        scripting->setGlobal("alert_label", alert_label.get());

        while (!glfwWindowShouldClose(window)) {
            scripting->reset();
            scripting->doScript("../app/scripts_lib/lib.lua");
            scripting->doScripts("../app/scripts");
            scripting->onInit();

            while (!glfwWindowShouldClose(window)) {
                glClearColor(0.1f, 0.1f, 0.1f, 1.f);
                glStencilMask(0xff);
                glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
                // glPolygonMode( GL_FRONT_AND_BACK, GL_LINE );

                scene->updateHierarchy();

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

                std::this_thread::sleep_for(std::chrono::milliseconds(32));
                glfwSwapBuffers(window);
                glfwPollEvents();

                scripting->onTick(glfwGetTime());

                {
                    card_select_widget->offset += glm::vec2(0.f, (float) Input::Shared->getScrollY() * 10.f);
                }

                if (Input::Shared->keyPressed(GLFW_MOUSE_BUTTON_LEFT)) {
                    shared_ptr<UIInteractable> intr;
                    if ((intr = gui_scene->ui_layer->traceInputCursor()) || (intr = scene->ui_layer->traceInputCursor())) {
                        scripting->onInteraction(InteractionEvent_Primary, intr);
                    }
                }

                if (Input::Shared->keyPressed(GLFW_MOUSE_BUTTON_RIGHT)) {
                    shared_ptr<UIInteractable> intr;
                    if ((intr = gui_scene->ui_layer->traceInputCursor()) || (intr = scene->ui_layer->traceInputCursor())) {
                        scripting->onInteraction(InteractionEvent_Secondary, intr);
                    }
                }

                if (Input::Shared->keyPressed(GLFW_MOUSE_BUTTON_MIDDLE)) {
                    shared_ptr<UIInteractable> intr;
                    if ((intr = gui_scene->ui_layer->traceInputCursor()) || (intr = scene->ui_layer->traceInputCursor())) {
                        scripting->onInteraction(InteractionEvent_Tertiary, intr);
                    }
                }

                if (Input::Shared->keyPressed(GLFW_KEY_ESCAPE)) {
                    scripting->onInteraction<UIInteractable>(InteractionEvent_Cancel);
                }

                if (Input::Shared->keyDown(GLFW_KEY_LEFT_ALT)) {
                    shared_ptr<UIInteractable> intr;
                    if ((intr = gui_scene->ui_layer->traceInputCursor()) || (intr = scene->ui_layer->traceInputCursor())) {
                        if (auto card_view = dynamic_pointer_cast<CardView>(intr)) {
                            if (!dynamic_pointer_cast<DeckView>(intr)) {
                                gui_card_zoomed_view->setCard(card_view->card, scripting->debugMetadataDescription(card_view->card.get()));
                                gui_card_zoomed_view->hidden = false;
                            }
                        }
                    }
                } else {
                    gui_card_zoomed_view->hidden = true;
                }

                if (Input::Shared->keyPressed(GLFW_KEY_R)) {
                    // force game reload
                    break;
                }

                Input::Shared->reset();
            }

            if (Input::Shared->keyDown(GLFW_KEY_R) && Input::Shared->keyDown(GLFW_KEY_LEFT_CONTROL)) {
                // force game restart
                break;
            }
        }
    }

    // @TODO: run destructors on LuaRefs before LuaHost closes luaL
    return 0;
}
