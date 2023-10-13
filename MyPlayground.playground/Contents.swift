import Foundation


class StationModule {
    let moduleName: String
    var drone: Drone?
    
    init(moduleName: String, drone: Drone?) {
        self.moduleName = moduleName
        self.drone = drone
    }
}

class ControlCenter: StationModule {
    var isLockedDown: Bool
    private var securityCode: String = "62N28R"
    
    init(isLockedDown: Bool, securityCode: String) {
        self.isLockedDown = isLockedDown
        self.securityCode = securityCode
        super.init(moduleName: "Control Center", drone: nil)
    }
    
    func lockdown(password: String) {
        if password == securityCode {
            isLockedDown = true
        } else {
            print("Wrong password")
        }
    }
    
    func infoAboutCenter() {
        if isLockedDown {
            print("ControlCenter is locked down")
        } else {
            print("ControlCenter is not under lock down")
        }
    }
}

class ResearchLab: StationModule {
    private var samples: [String]
    
    init() {
        samples = []
        super.init(moduleName: "Research Lab", drone: nil)
    }
    
    func addSamples(newSample: String) {
        samples.append(newSample)
    }
}

class LifeSupportSystem: StationModule {
    private let oxygenLevel: Double
    
    init(oxygenLevel: Double) {
        self.oxygenLevel = oxygenLevel
        super.init(moduleName: "Life Support System", drone: nil)
    }
    
    func oxyStatus() {
        print("Oxygen level: \(oxygenLevel)")
    }
}

class Drone {
    var task: String?
    unowned var assignedModule: StationModule
    weak var missionControlLink: MissionControl?
    
    init(assignedModule: StationModule) {
        self.assignedModule = assignedModule
    }
    
    func droneStatus() {
        if let task = task {
            print("Drone is currently working on: \(task)")
        } else {
            print("Drone is free to use")
        }
    }
}

class OrbitronSpaceStation {
    let controlCenter: ControlCenter
    let researchLab: ResearchLab
    let lifeSupportSystem: LifeSupportSystem
    var missionControlLink: MissionControl?
    
    init(controlCenter: ControlCenter, researchLab: ResearchLab, lifeSupportSystem: LifeSupportSystem) {
        self.controlCenter = controlCenter
        self.researchLab = researchLab
        self.lifeSupportSystem = lifeSupportSystem
        
        self.controlCenter.drone = Drone(assignedModule: controlCenter)
        self.researchLab.drone = Drone(assignedModule: researchLab)
        self.lifeSupportSystem.drone = Drone(assignedModule: lifeSupportSystem)
    }
    
    func lockDownOrbitron(password: String) {
        controlCenter.lockdown(password: password)
    }
    
    func assaignTaskToDrone(module: StationModule, task: String) {
        module.drone?.task = task
    }
}



class MissionControl {
    weak var spaceStation: OrbitronSpaceStation?
    
    init(spaceStation: OrbitronSpaceStation?) {
        self.spaceStation = spaceStation
    }
    
    func connectToSpaceStation(spaceStation: OrbitronSpaceStation) {
        spaceStation.missionControlLink = self
        print("The connection was successfully established")
    }
    
    func requestControlCenterStatus() {
        if let controlCenter = spaceStation?.controlCenter {
            controlCenter.infoAboutCenter()
        } else {
            print("Orbitron Space Station not connected.")
        }
    }
    
    func requestOxygenStatus() {
        if let lifeSupportSystem = spaceStation?.lifeSupportSystem {
            lifeSupportSystem.oxyStatus()
        } else {
            print("Orbitron Space Station not connected.")
        }
    }
    
    func requestDroneStatus(drone: Drone) { drone.droneStatus() }
}



let controlCenter = ControlCenter(isLockedDown: false, securityCode: "62N28R")
let researchLab = ResearchLab()
let lifeSupportSystem = LifeSupportSystem(oxygenLevel: 100.0)

let orbitronSpaceStation = OrbitronSpaceStation(controlCenter: controlCenter, researchLab: researchLab, lifeSupportSystem: lifeSupportSystem)

let missionControl = MissionControl(spaceStation: orbitronSpaceStation)
missionControl.connectToSpaceStation(spaceStation: orbitronSpaceStation) // connecting to space station
missionControl.requestControlCenterStatus() // checking status of control center

// assigning tasks to drones
orbitronSpaceStation.assaignTaskToDrone(module: controlCenter, task: "Monitor and control station security")
orbitronSpaceStation.assaignTaskToDrone(module: researchLab, task: "Collect and analyze samples")
orbitronSpaceStation.assaignTaskToDrone(module: lifeSupportSystem, task: "Monitor and maintain oxygen levels")

// checking drone status
controlCenter.drone?.droneStatus()
researchLab.drone?.droneStatus()
lifeSupportSystem.drone?.droneStatus()

missionControl.requestOxygenStatus() // checking oxygen level
orbitronSpaceStation.lockDownOrbitron(password: "123") // checking lockdown
orbitronSpaceStation.controlCenter.infoAboutCenter()// checking center
orbitronSpaceStation.lockDownOrbitron(password: "62N28R") // locking down
orbitronSpaceStation.controlCenter.infoAboutCenter() // last status
