import { SentientActTeamListView } from '../../sentientAct/SentientActTeamListView';
import { GhostWalkActTeamListItem } from './GhostWalkActTeamListItem';

export class GhostWalkActTeamListView extends SentientActTeamListView {
    public constructor(parent?) {
        super(parent);
        this.teamActivityType = 10;
        this.teamSubType = 1;
        this.alertContent = '当前队伍目标不是百鬼夜行<br>是否退出队伍匹配';
        this.teamListItem = GhostWalkActTeamListItem;
    }
}

window['GhostWalkActTeamListView'] = GhostWalkActTeamListView;
