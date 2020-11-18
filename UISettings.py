
class StateMachineDraw:
    resolution = (1920, 1080)
    boxPos = [[.1, .1],
                 [-.1, .1],
                 [-.3, 0],
                 [-.1, -.1],
                 [.1, -.1],
                 [.3, 0]]
    boxHeight = .05
    boxWidth = .09
    boxSelectedColor = (255, 255, 255)
    boxColor = (100, 100, 100)

    def getBoxPos(self, buttonNum):
        return self.resolution[0] * self.boxPos[buttonNum][0], self.resolution[1] * self.boxPos[buttonNum][1]

    def setResolution(self, res):
        self.resolution = res

    def getBoxSize(self):
        return self.resolution[0] * self.boxWidth, self.resolution[0] * self.boxHeight

class GUIDraw:
    resolution = (1920, 1080)
    bgColor = (150, 150, 150)
    controllBoxColor = (255, 150, 150)
    controllTextColor = (0, 0, 0)
    controllPosition = (0, -.4)
    controllPositionOffset = (.1, 0)
    generalTextColor = (150, 150, 255)
    generalTextPosition = (0,0)
    moveTextOffset = (0, -.01)
    moveTextColor = (180, 180, 180)

    debugTextColor = (255, 0, 0)
    debugTextPos = (-.4, .4)