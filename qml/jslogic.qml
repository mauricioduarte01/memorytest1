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
import "utils.js" as Util

import Example 1.0


MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'apptest.md'
    automaticOrientation: true

    PageHeader { visible: false }

    width: units.gu(45)
    height: units.gu(75)



    //https://stackoverflow.com/a/2450976/6622587
    function shuffle(model){
        var currentIndex = model.count, temporaryValue, randomIndex;

        // While there remain elements to shuffle...
        while (0 !== currentIndex) {
            // Pick a remaining element...
            randomIndex = Math.floor(Math.random() * currentIndex)
            currentIndex -= 1
            // And swap it with the current element.
            // the dictionaries maintain their reference so a copy should be made
            // https://stackoverflow.com/a/36645492/6622587
            temporaryValue = JSON.parse(JSON.stringify(model.get(currentIndex)))
            model.set(currentIndex, model.get(randomIndex))
            model.set(randomIndex, temporaryValue);
        }
        return model;
    }

    ListModel{
        id: listModel

        Component.onCompleted: {
            fillData()
        }

        function fillData() {
            var assetPath = "../assets/"
            append({"imageSource": assetPath + "cow.svg", color: "red"})
            append({"imageSource": assetPath + "cow.svg", color: "red"})
            append({"imageSource": assetPath + "dog.svg", color: "blue"})
            append({"imageSource": assetPath + "dog.svg", color: "blue"})
            append({"imageSource": assetPath + "sheep.svg", color: "green"})
            append({"imageSource": assetPath + "sheep.svg", color: "green"})
        }
    }



    Page {
        PageHeader { visible: false }
        id: wrapper
        //define the number of columns and depending on the device xy orientation
        property int n_columns: height > width ? 2 : 3
        property int n_rows: height > width ? 4 : 3
        //formula to auto-resize the cards to keep aspect ratio
        property int card_size: Math.min (width / n_columns, height / n_rows) * 0.9
        //spacing between cards
        property int card_xspacing: (width - card_size * n_columns) / (n_columns + 1)
        property int card_yspacing: (height - card_size * n_rows) / (n_rows + 1)


        Grid {
            x: wrapper.card_xspacing
            y: wrapper.card_yspacing
            columns: wrapper.n_columns
            rows: wrapper.n_rows

            columnSpacing: wrapper.card_xspacing
            rowSpacing: wrapper.card_yspacing

            Repeater {
                id: repeater
                anchors.fill: parent
                model: Util.shuffle(listModel)

                delegate: Card {
                    height: wrapper.card_size
                    width: wrapper.card_size
                    color: model.color
                    imageSource: model.imageSource


                }
            }
        }


    }
}

