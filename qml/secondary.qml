/*
 * Copyright (C) 2022  Mauricio Duarte
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * apptest is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import Example 1.0

////CPP Implementation
//void MemoryGame::start(){

//	while (again) {
//		    srand((unsigned int) time(nullptr));
//	    //Number of columns and rows
//	    for (int row = 0; row < 4; row++) {
//		for (int column = 0; column < 4; column++) {
//		    //Initialize a random matrix
//		    matrix[row][column] = rand() % 8 + 1;
//		    matrix2[row][column] = false;


MainView {
    id: game
    objectName: 'mainView'
    applicationName: 'apptest.md'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)


    Component.onCompleted: start_game()


    //2D Array
    property var cards: [cow, cow2, sheep, sheep2, dog1, dog2]
    property var colors: ["aquamarine", "pink", "darkmagenta", "aqua"]

    property var flipped_cards: []
    property var matched_cards: []

    //La funcion shuffle recibe un "value" como parametro
    //typical swap function
    function shuffle (value) {
        var i = value.length, j, temp
        if (i === 0)
            return false
        while (--i) {
            j = Math.floor (Math.random() * (i + 1))
            temp = value[i]
            value[i] = value[j]
            value[j] = temp
        }
    }

    /////////////////////
    function start_game () {
        flipped_cards = []
        matched_cards = []
        var cards = game.cards.slice ()
        shuffle (cards)
        for (var i = 0; i < cards.length; i++) {
            cards[i].reset ()
            cards[i].color = game.colors[Math.floor (i / 2)]
        }
    }

    function flip_card (card) {
        // Can't flip the same card twice
        for (var i = 0; i < flipped_cards.length; i++)
            if (flipped_cards[i] === card)
                return

        // Can't flip already matched cards
        if (is_matched (card))
            return

        // Waiting for match to be checked
        if (flipped_cards.length >= 2)
            return

        flipped_cards[flipped_cards.length] = card
        card.flip ()

        if (flipped_cards.length === 2) {
            if (card.color === flipped_cards[0].color) {
                matched_cards[matched_cards.length] = flipped_cards[0]
                matched_cards[matched_cards.length] = flipped_cards[1]
                if (matched_cards.length == cards.length)
                    end_game_timer.start ()
                else
                    flipped_cards = []
            }
            else
                bad_match_timer.start ()
        }
    }

    function is_matched (card) {
        for (var i = 0; i < matched_cards.length; i++)
            if (matched_cards[i] === card)
                return true
        return false
    }

    // Timer to delay flipping over a bad match
    Timer {
        id: bad_match_timer
        interval: 1000
        signal done ()
        onTriggered: {
            flipped_cards[0].reset ()
            flipped_cards[1].reset ()
            flipped_cards = []
        }
    }


    Page {
        id: wrapper
        property int n_columns: height > width ? 2 : 3
        property int n_rows: height > width ? 4 : 3
        property int button_size: Math.min (width / n_columns, height / n_rows) * 0.9
        property int button_radius: 10
        property int button_xspacing: (width - button_size * n_columns) / (n_columns + 1)
        property int button_yspacing: (height - button_size * n_rows) / (n_rows + 1)

        PageHeader {visible: false }
        Grid{
            x: wrapper.button_xspacing
            y: wrapper.button_yspacing
            columns: wrapper.n_columns
            rows: wrapper.n_rows

            columnSpacing: wrapper.button_xspacing
            rowSpacing: wrapper.button_yspacing

//            id: grilla
//            anchors.fill: parent
//            height: 5; width: 10
//            rows: 3; columns: 3

//            spacing: 2

            Card{
                id: cow
                height: 100
                width: 100
                imageSource: "../assets/cow.svg"
                color: "red"
                onActivated: game.flip_card (cow)

            }
            Card{
                id: sheep
                height: 100
                width: 100
                imageSource: "../assets/sheep.svg"
                color: "green"
                onActivated: game.flip_card (sheep)

            }
            Card{
                id: cow2
                height: 100
                width: 100
                imageSource: "../assets/cow.svg"
                color: "red"
                onActivated: game.flip_card (cow2)
            }
            Card{
                id: sheep2

                height: 100
                width: 100
                imageSource: "../assets/sheep.svg"
                color: "green"
                onActivated: game.flip_card (sheep2)

            }
            Card{
                id: dog1

                height: 100
                width: 100
                imageSource: "../assets/dog.svg"
                color: "blue"
                onActivated: game.flip_card (dog1)

            }
            Card{
                id: dog2

                height: 100
                width: 100
                imageSource: "../assets/dog.svg"
                color: "blue"
                onActivated: game.flip_card (dog2)

            }

        }
    }
}
