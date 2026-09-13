import 'dotenv/config';
import mariadb from 'mariadb';

async function main() {
    console.log('🗑️ Dropping all tables in the database...');

    let host = process.env.DATABASE_HOST ?? 'localhost';
    
    const pool = mariadb.createPool({
        host,
        port: Number(process.env.DATABASE_PORT ?? 3306),
        user: process.env.DATABASE_USER ?? 'root',
        password: process.env.DATABASE_PASSWORD ?? '',
        database: process.env.DATABASE_NAME,
        connectionLimit: 1
    });

    let conn;
    try {
        conn = await pool.getConnection();

        // Disable foreign key checks for this connection
        await conn.query('SET FOREIGN_KEY_CHECKS = 0;');

        // Get all tables
        const rows = await conn.query('SELECT table_name AS TABLE_NAME FROM information_schema.tables WHERE table_schema = DATABASE()');

        if (!rows || rows.length === 0) {
            console.log('ℹ️ No tables found in the database.');
        } else {
            for (const row of rows) {
                const tableName = row.TABLE_NAME;
                await conn.query(`DROP TABLE IF EXISTS \`${tableName}\`;`);
                console.log(`Dropped table: ${tableName}`);
            }
        }

        // Re-enable foreign key checks
        await conn.query('SET FOREIGN_KEY_CHECKS = 1;');

        console.log('✅ All tables dropped successfully');
    } catch (err) {
        console.error('❌ Dropping tables failed:', err);
        process.exitCode = 1;
    } finally {
        if (conn) await conn.release();
        await pool.end();
    }
}

main();
