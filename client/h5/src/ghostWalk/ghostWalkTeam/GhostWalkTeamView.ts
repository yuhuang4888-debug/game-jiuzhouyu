import { SentientActTeamView } from '../../sentientAct/SentientActTeamView';
import { GhostWalkActTeamApplyView } from './GhostWalkActTeamApplyView';
import { GhostWalkActTeamListView } from './GhostWalkActTeamListView';
import { GhostWalkActTeamRoleView } from './GhostWalkActTeamRoleView';

export class GhostWalkTeamView extends SentientActTeamView {
    constructor() {
        super();
        this.viewclass_list = [GhostWalkActTeamListView, GhostWalkActTeamRoleView, GhostWalkActTeamApplyView];
        this.teamActivityType = 10;
        this.teamSubType = 1;
        this.titleText = "百鬼夜行"
    }
}

window['GhostWalkTeamView'] = GhostWalkTeamView;
