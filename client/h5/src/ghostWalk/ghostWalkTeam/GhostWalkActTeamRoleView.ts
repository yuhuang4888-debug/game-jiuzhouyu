import { EventName } from '../../common/EventName';
import { SentientActTeamRoleView } from '../../sentientAct/SentientActTeamRoleView';
import { GlobalEventSystem } from '../../util/DeclareGlobalVar';

export class GhostWalkActTeamRoleView extends SentientActTeamRoleView {
    constructor(parent?) {
        super(parent);

        this.teamActivityType = 10;
        this.teamSubType = 1;
        this.alertContent = '当前队伍目标不是百鬼夜行<br>是否退出队伍匹配';
        this.is_show_asssit =false
        this.EnterFunc = () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkBossEntryView');
            GlobalEventSystem.Fire(EventName.CLOSE_VIEW, 'GhostWalkTeamView');
        };
        this.OpenClumpView = () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'DungeonEquipClumpView');
        };
    }
}

window['GhostWalkActTeamRoleView'] = GhostWalkActTeamRoleView;
