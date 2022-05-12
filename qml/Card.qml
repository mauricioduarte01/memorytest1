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

Shape{
    id: card
    //radius: medium
    signal activated ()
    property alias imageSource: imagenes.source
    //property var color: "white"
    //color: card.color

    function flip () {
        rotation.angle = 180
    }

    function reset () {
        rotation.angle = 0
    }

    Image{
        id: imagenes
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.8
        height: parent.height * 0.8
        fillMode: Image.PreserveAspectFit
    }

    Flipable{
        id: flipable

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height

        property bool flipped: false

        front: Rectangle {
            color: "yellow"
            anchors.fill: parent
            radius: 5
        }
        back: imagenes

        //        front: Image { source: "../assets/sheep.svg" ; anchors.centerIn: parent }
        //        back: Image { source: "../assets/cow.svg"; anchors.centerIn: parent }
        transform: Rotation {
            id: rotation
            origin.x: card.width / 2
            origin.y: card.height / 2
            axis.x: 0
            axis.y: 1
            axis.z: 0
            Behavior on angle {
                NumberAnimation {
                    easing: UbuntuAnimation.StandardEasing
                }
            }
        }

                  states: State {
                      name: "back"
                      PropertyChanges { target: rotation; angle: 180 }
                      when: flipable.flipped
                  }

                  transitions: Transition {
                      NumberAnimation { target: rotation; property: "angle"; duration: 500 }
                  }

//                  MouseArea {
//                      anchors.fill: parent
//                      onClicked: flipable.flipped = !flipable.flipped
//                  }
    }
//    MouseArea {
//        anchors.fill: parent
//        onClicked: card.activated()
//    }
    MouseArea {
        anchors.fill: parent
        onPressed: {
            flipable.flipped = !flipable.flipped
            //sound.play();
        }
    }
}

