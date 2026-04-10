import { LightningElement, track } from 'lwc';

export default class Minesweeper extends LightningElement {
    @track cells = [];
    @track gameState = 'ready'; // ready, playing, won, lost
    @track minesLeft = 0;
    @track timeElapsed = 0;
    @track rows = 9;
    @track cols = 9;
    @track totalMines = 10;

    timerInterval;
    firstClick = true;

    get gameStatus() {
        if (this.gameState === 'won') return 'You Won!';
        if (this.gameState === 'lost') return 'Game Over!';
        return 'Click to start';
    }

    get isGameOver() {
        return this.gameState === 'won' || this.gameState === 'lost';
    }

    get difficultyOptions() {
        return [
            { label: 'Easy (9x9, 10 mines)', value: 'easy' },
            { label: 'Medium (16x16, 40 mines)', value: 'medium' },
            { label: 'Hard (16x30, 99 mines)', value: 'hard' }
        ];
    }

    connectedCallback() {
        this.initializeGame();
    }

    disconnectedCallback() {
        this.stopTimer();
    }

    initializeGame() {
        this.stopTimer();
        this.firstClick = true;
        this.timeElapsed = 0;
        this.gameState = 'ready';
        this.minesLeft = this.totalMines;

        this.cells = [];
        for (let row = 0; row < this.rows; row++) {
            for (let col = 0; col < this.cols; col++) {
                this.cells.push({
                    id: `${row}-${col}`,
                    row,
                    col,
                    isMine: false,
                    isRevealed: false,
                    isFlagged: false,
                    neighborMines: 0,
                    cssClass: 'cell'
                });
            }
        }
        this.cells = [...this.cells];
    }

    placeMines(avoidRow, avoidCol) {
        let minesPlaced = 0;
        while (minesPlaced < this.totalMines) {
            const randomIndex = Math.floor(Math.random() * this.cells.length);
            const cell = this.cells[randomIndex];

            if (!cell.isMine && !(cell.row === avoidRow && cell.col === avoidCol)) {
                cell.isMine = true;
                minesPlaced++;
            }
        }

        this.calculateNeighborMines();
    }

    calculateNeighborMines() {
        this.cells.forEach(cell => {
            if (!cell.isMine) {
                cell.neighborMines = this.countNeighborMines(cell.row, cell.col);
            }
        });
    }

    countNeighborMines(row, col) {
        let count = 0;
        for (let r = row - 1; r <= row + 1; r++) {
            for (let c = col - 1; c <= col + 1; c++) {
                if (r === row && c === col) continue;
                const neighbor = this.getCell(r, c);
                if (neighbor && neighbor.isMine) count++;
            }
        }
        return count;
    }

    getCell(row, col) {
        return this.cells.find(c => c.row === row && c.col === col);
    }

    handleCellClick(event) {
        if (this.isGameOver) return;

        const cellId = event.currentTarget.dataset.id;
        const [row, col] = cellId.split('-').map(Number);
        const cell = this.getCell(row, col);

        if (!cell || cell.isRevealed || cell.isFlagged) return;

        if (this.firstClick) {
            this.placeMines(row, col);
            this.firstClick = false;
            this.gameState = 'playing';
            this.startTimer();
        }

        this.revealCell(cell);
        this.checkWinCondition();
    }

    handleCellRightClick(event) {
        event.preventDefault();
        if (this.isGameOver || this.gameState === 'ready') return;

        const cellId = event.currentTarget.dataset.id;
        const [row, col] = cellId.split('-').map(Number);
        const cell = this.getCell(row, col);

        if (!cell || cell.isRevealed) return;

        cell.isFlagged = !cell.isFlagged;
        this.minesLeft += cell.isFlagged ? -1 : 1;
        this.updateCellClass(cell);
        this.cells = [...this.cells];
    }

    revealCell(cell) {
        if (cell.isRevealed || cell.isFlagged) return;

        cell.isRevealed = true;

        if (cell.isMine) {
            this.gameOver(false);
            return;
        }

        if (cell.neighborMines === 0) {
            for (let r = cell.row - 1; r <= cell.row + 1; r++) {
                for (let c = cell.col - 1; c <= cell.col + 1; c++) {
                    if (r === cell.row && c === cell.col) continue;
                    const neighbor = this.getCell(r, c);
                    if (neighbor && !neighbor.isRevealed) {
                        this.revealCell(neighbor);
                    }
                }
            }
        }

        this.updateCellClass(cell);
        this.cells = [...this.cells];
    }

    updateCellClass(cell) {
        let classes = ['cell'];

        if (cell.isRevealed) {
            classes.push('revealed');
            if (cell.isMine) {
                classes.push('mine');
            } else if (cell.neighborMines > 0) {
                classes.push(`number-${cell.neighborMines}`);
            }
        } else if (cell.isFlagged) {
            classes.push('flagged');
        }

        cell.cssClass = classes.join(' ');
    }

    checkWinCondition() {
        const allNonMinesRevealed = this.cells
            .filter(c => !c.isMine)
            .every(c => c.isRevealed);

        if (allNonMinesRevealed) {
            this.gameOver(true);
        }
    }

    gameOver(won) {
        this.gameState = won ? 'won' : 'lost';
        this.stopTimer();

        this.cells.forEach(cell => {
            if (cell.isMine) {
                cell.isRevealed = true;
                this.updateCellClass(cell);
            }
        });
        this.cells = [...this.cells];
    }

    startTimer() {
        this.timerInterval = setInterval(() => {
            this.timeElapsed++;
        }, 1000);
    }

    stopTimer() {
        if (this.timerInterval) {
            clearInterval(this.timerInterval);
            this.timerInterval = null;
        }
    }

    handleReset() {
        this.initializeGame();
    }

    handleDifficultyChange(event) {
        const difficulty = event.detail.value;

        switch (difficulty) {
            case 'easy':
                this.rows = 9;
                this.cols = 9;
                this.totalMines = 10;
                break;
            case 'medium':
                this.rows = 16;
                this.cols = 16;
                this.totalMines = 40;
                break;
            case 'hard':
                this.rows = 16;
                this.cols = 30;
                this.totalMines = 99;
                break;
        }

        this.initializeGame();
    }

    get cellContent() {
        return this.cells.map(cell => {
            let content = '';
            if (cell.isRevealed) {
                if (cell.isMine) {
                    content = '💣';
                } else if (cell.neighborMines > 0) {
                    content = cell.neighborMines.toString();
                }
            } else if (cell.isFlagged) {
                content = '🚩';
            }
            return { ...cell, content };
        });
    }

    get gridStyle() {
        return `grid-template-columns: repeat(${this.cols}, 30px); grid-template-rows: repeat(${this.rows}, 30px);`;
    }
}
