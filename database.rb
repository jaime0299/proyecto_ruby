require 'sqlite3'

class DatabaseSchool
    def verificaLog(user,pass)
        begin
            db = SQLite3::Database.open "escuela.db"

            stm = db.prepare "SELECT * FROM usuarios WHERE user = ? AND pass = ?"
            stm.bind_params user,pass
            res = stm.execute
            con=0
            usuario=[]
            while row = res.next
                usuario=row
                con=con+1
            end
            if con==1
                return true, usuario
            else
                return false, usuario
            end
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        ensure
            stm.close if stm
            db.close if db
        end
    end
    def insertarUser(user, nombre, pass, tipo)
        begin
        
            db = SQLite3::Database.open "escuela.db"
            ret=true
            stm = db.prepare "INSERT INTO usuarios(user,nombre,pass,tipo) VALUES(?,?,?,?)"
            stm.bind_params user,nombre,pass,tipo
            stm.execute
        
        rescue SQLite3::Exception => e 
            
            puts "Exception occurred"
            puts e
            ret=false
            
        ensure
            stm.close if stm
            db.close if db
            return ret
        end
    end
    def updateUser(user, nombre, pass, tipo)
        begin
        
            db = SQLite3::Database.open "escuela.db"
    
            stm = db.prepare "UPDATE usuarios(user,nombre,pass,tipo) SET(?,?,?,?)"
            stm.bind_params user,pass,tipo
            stm.execute
        
        rescue SQLite3::Exception => e 
            
            puts "Exception occurred"
            puts e
            
        ensure
            stm.close if stm
            db.close if db
        end
    end
    def deleteUser(user, name, type)
        begin
        
            db = SQLite3::Database.open "escuela.db"
            ret=true
            stm = db.prepare "DELETE FROM usuarios WHERE user = ?"
            stm.bind_param 1, user
            stm.execute

            if type=="Student"
                stm2 = db.prepare "DELETE FROM calificaciones WHERE alumno = ?"
            elsif type=="Teacher"
                stm2 = db.prepare "UPDATE materias SET maestro=null WHERE maestro=?"
            end
            stm2.bind_param 1, name
            stm2.execute
        
        rescue SQLite3::Exception => e 
            
            puts "Exception occurred"
            puts e
            ret=false
            
        ensure
            stm.close if stm
            stm2.close if stm2
            db.close if db
            return ret
        end
    end
    def selectUsers(tipo)
        usuarios=Array.new()
        db = SQLite3::Database.open "escuela.db"
        stm = db.prepare "SELECT * FROM usuarios WHERE tipo = ?"
        stm.bind_param 1, tipo
        res = stm.execute

        while row = res.next
            usuarios.push({
                user: row[0],
                name: row[1],
                pass: row[2],
                tipo: row[3]
            })
        end

        stm.close if stm
        db.close if db
        return usuarios
    end
    def selectAllUsers()
        db = SQLite3::Database.open "escuela.db"
        res = db.execute "SELECT * FROM usuarios"
        db.close if db
        return res
    end
    def asignaciones(teacher, materia)
        begin
        
            db = SQLite3::Database.open "escuela.db"
            ret=true
            stm = db.prepare "UPDATE materias SET maestro=? WHERE nombre=?"
            stm.bind_params teacher,materia
            stm.execute
        
        rescue SQLite3::Exception => e 
            
            puts "Exception occurred"
            puts e
            ret=false
            
        ensure
            stm.close if stm
            db.close if db
            return ret
        end
    end
    def bajasMaterias(user, materia)
        begin
        
            db = SQLite3::Database.open "escuela.db"
    
            stm = db.prepare "DELETE FROM asignaciones WHERE usuario = ? AND materia = ?"
            stm.bind_params user,materia
            stm.execute
        
        rescue SQLite3::Exception => e 
            
            puts "Exception occurred"
            puts e
            
        ensure
            stm.close if stm
            db.close if db
        end
    end
    def agregarMateria(materia)
        begin
        
            db = SQLite3::Database.open "escuela.db"
            ret=true
            stm = db.prepare "INSERT INTO materias(nombre) VALUES(?)"
            stm.bind_params materia
            stm.execute
        
        rescue SQLite3::Exception => e 
            
            puts "Exception occurred"
            puts e
            ret=false
            
        ensure
            stm.close if stm
            db.close if db
            return ret
        end
    end
    def getMaterias()
        db = SQLite3::Database.open "escuela.db"
        res = db.execute "SELECT * FROM materias"
        db.close if db
        return res
    end
    def getMateriasM(maestro)
        materias=Array.new()
        db = SQLite3::Database.open "escuela.db"
        stm = db.prepare "SELECT * FROM materias WHERE maestro = ?"
        stm.bind_param 1, maestro
        res = stm.execute

        while row = res.next
            materias.push({
                class: row[0],
                teacher: row[1]
            })
        end

        stm.close if stm
        db.close if db
        return materias
    end
    def capturaCalificaciones(alumno, materia, calificacion)
        begin
        
            db = SQLite3::Database.open "escuela.db"
            ret = true
            stm = db.prepare "UPDATE calificaciones SET calificacion=? WHERE alumno=? AND materia=?"
            stm.bind_params calificacion, alumno, materia
            stm.execute
        
        rescue SQLite3::Exception => e 
            
            puts "Exception occurred"
            puts e
            ret=false
        ensure
            stm.close if stm
            db.close if db
            return ret
        end
    end
    def getAlumnos(maestro)
        alumnos=Array.new
        db = SQLite3::Database.open "escuela.db"
        db.results_as_hash = true
        stm = db.prepare "SELECT c.alumno, c.materia, c.calificacion FROM calificaciones AS c, materias AS m WHERE c.materia=m.nombre AND m.maestro= ?"
        stm.bind_param 1, maestro
        res = stm.execute
        while row = res.next
            alumnos.push({
                name: row[0],
                class: row[1],
                cal: row[2]
            })
        end

        stm.close if stm
        db.close if db
        return alumnos
    end
    def enrollStudent(materia, alumno)
        begin
        
            db = SQLite3::Database.open "escuela.db"
            ret=true
            stm = db.prepare "INSERT INTO calificaciones(materia,alumno) VALUES(?,?)"
            stm.bind_params materia, alumno
            stm.execute
        
        rescue SQLite3::Exception => e 
            
            puts "Exception occurred"
            puts e
            ret=false
            
        ensure
            stm.close if stm
            db.close if db
            return ret
        end
    end
    def getGrades(alumno)
        grades=Array.new
        db = SQLite3::Database.open "escuela.db"
        db.results_as_hash = true
        stm = db.prepare "SELECT c.materia, c.calificacion, m.maestro FROM calificaciones AS c, materias AS m WHERE c.materia=m.nombre AND c.alumno=?"
        stm.bind_param 1, alumno
        res = stm.execute
        while row = res.next
            grades.push({
                class: row[0],
                cal: row[1],
                teacher: row[2]
            })
        end

        stm.close if stm
        db.close if db
        return grades
    end
end

